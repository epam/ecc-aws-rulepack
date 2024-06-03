import os
import json
import boto3
import random
import botocore
from pathlib import Path

readonly_role_name = "github_ci_readonly_ecc-aws-rulepack"
ci_role_name = "github_ci_ecc-aws-rulepack"
policy_name = 'custodian_readonly'


def check_role_exists(readonly_role_name_color):
    client = boto3.client('iam')
    try:
        response = client.get_role(RoleName=readonly_role_name_color)
        role_exists = True
    except client.exceptions.NoSuchEntityException:
        role_exists = False
    return role_exists


def check_policy_exists(role_name, policy_name):
    client = boto3.client('iam')
    try:
        response = client.get_role_policy(RoleName=role_name, PolicyName=policy_name)
        policy_exists = True
    except client.exceptions.NoSuchEntityException:
        policy_exists = False
    return policy_exists


def create_delete_readonly_role_aws(create=False, delete=False, color='', role_name=None):
    if create:
        role_id = random.randint(1000, 9999)
        role_name = f"{readonly_role_name}_{color}_{role_id}"

    sts = boto3.client("sts")
    account_id = sts.get_caller_identity()["Account"]
    client = boto3.client('iam')
    if create:
        trust_policy = {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": f"arn:aws:iam::{account_id}:role/{ci_role_name}"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
        if not check_role_exists(role_name):
            try:
                role = client.create_role(
                    RoleName=role_name, AssumeRolePolicyDocument=json.dumps(trust_policy)
                )
                print(f"Created role {role_name}.")
            except botocore.exceptions.ClientError:
                print(f"Couldn't create role {role_name}.")
                raise
            else:
                return role.get("Role", {})
        else:
            try:
                role = client.update_assume_role_policy(
                    RoleName=role_name, PolicyDocument=json.dumps(trust_policy)
                )
                print(f"Updated trust policy for role {role_name}.")
            except botocore.exceptions.ClientError:
                print(f"Couldn't update trust policy for role {role_name}.")
                raise
            else:
                return role.get("Role", {})
    elif delete:
        if check_role_exists(role_name):
            try:
                if check_policy_exists(role_name, policy_name):
                    client.delete_role_policy(RoleName=role_name, PolicyName=policy_name)
                client.delete_role(RoleName=role_name)
                print(f"Deleted role {role_name}.")
            except botocore.exceptions.ClientError:
                print(f"Couldn't delete role {role_name}.")
                raise


def set_readonly_role_permissions_aws(resource, role_name):
    root_path = Path(os.getcwd()).parents[1]
    iam_path = os.path.join(root_path, 'auto_policy_testing', 'iam', resource + '.json')
    with open(iam_path, 'r') as f:
        inline_policy = json.load(f)

    client = boto3.client('iam')
    response = client.put_role_policy(
        RoleName=role_name,
        PolicyName=policy_name,
        PolicyDocument=json.dumps(inline_policy)
    )
