import boto3
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    arn = event["SecretId"]
    token = event["ClientRequestToken"]
    step = event["Step"]

    endpoint = os.environ.get("SECRETS_MANAGER_ENDPOINT")
    client = boto3.client("secretsmanager", endpoint_url=endpoint) if endpoint else boto3.client("secretsmanager")

    metadata = client.describe_secret(SecretId=arn)
    if "RotationEnabled" in metadata and not metadata["RotationEnabled"]:
        raise ValueError("Secret %s is not enabled for rotation" % arn)

    versions = metadata["VersionIdsToStages"]
    if token not in versions:
        raise ValueError("Secret version %s has no stage for rotation of secret %s." % (token, arn))
    if "AWSCURRENT" in versions[token]:
        logger.info("Version %s already AWSCURRENT for %s" % (token, arn))
        return
    if "AWSPENDING" not in versions[token]:
        raise ValueError("Secret version %s not set as AWSPENDING for %s." % (token, arn))

    if step == "createSecret":
        create_secret(client, arn, token)
    elif step == "setSecret":
        logger.info("setSecret: no-op for %s" % arn)
    elif step == "testSecret":
        logger.info("testSecret: no-op for %s" % arn)
    elif step == "finishSecret":
        finish_secret(client, arn, token)
    else:
        raise ValueError("Invalid step parameter")


def create_secret(client, arn, token):
    client.get_secret_value(SecretId=arn, VersionStage="AWSCURRENT")
    try:
        client.get_secret_value(SecretId=arn, VersionId=token, VersionStage="AWSPENDING")
        logger.info("createSecret: AWSPENDING already exists for %s" % arn)
    except client.exceptions.ResourceNotFoundException:
        exclude = os.environ.get("EXCLUDE_CHARACTERS", "/@\"'\\")
        passwd = client.get_random_password(ExcludeCharacters=exclude, PasswordLength=32)
        client.put_secret_value(
            SecretId=arn,
            ClientRequestToken=token,
            SecretString=passwd["RandomPassword"],
            VersionStages=["AWSPENDING"],
        )
        logger.info("createSecret: put AWSPENDING for %s" % arn)


def finish_secret(client, arn, token):
    metadata = client.describe_secret(SecretId=arn)
    current_version = None
    for version, stages in metadata["VersionIdsToStages"].items():
        if "AWSCURRENT" in stages:
            if version == token:
                logger.info("finishSecret: %s already AWSCURRENT" % version)
                return
            current_version = version
            break
    client.update_secret_version_stage(
        SecretId=arn,
        VersionStage="AWSCURRENT",
        MoveToVersionId=token,
        RemoveFromVersionId=current_version,
    )
    logger.info("finishSecret: set AWSCURRENT to %s for %s" % (token, arn))
