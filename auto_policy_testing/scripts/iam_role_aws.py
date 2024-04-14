import os
import json
import boto3
import botocore
from pathlib import Path

readonly_role_name = "github_ci_readonly_ecc-aws-rulepack"
ci_role_name = "github_ci_ecc-aws-rulepack"
policy_name = 'custodian_readonly'

def check_role_exists(color):
    client = boto3.client('iam')
    try:
        response = client.get_role(RoleName=f"{readonly_role_name}_{color}")
        role_exists = True
    except client.exceptions.NoSuchEntityException:
        role_exists = False
    return role_exists

def check_policy_exists(readonly_role_name, policy_name):
    client = boto3.client('iam')
    try:
        response = client.get_role_policy(RoleName=readonly_role_name, PolicyName=policy_name)
        policy_exists = True
    except client.exceptions.NoSuchEntityException:
        policy_exists = False
    return policy_exists

def create_delete_readonly_role_aws(create=False, delete=False, color = ''):
    readonly_role_name_color = f"{readonly_role_name}_{color}"
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
        if not check_role_exists(color):
            try:
                role = client.create_role(
                    RoleName=readonly_role_name_color, AssumeRolePolicyDocument=json.dumps(trust_policy)
                )
                print(f"Created role {readonly_role_name_color}.")
            except botocore.exceptions.ClientError:
                print(f"Couldn't create role {readonly_role_name_color}.")
                raise
            else:
                return role
        else:
            try:
                role = client.update_assume_role_policy(
                    RoleName=readonly_role_name_color, PolicyDocument=json.dumps(trust_policy)
                )
                print(f"Updated trust policy for role {readonly_role_name_color}.")
            except botocore.exceptions.ClientError:
                print(f"Couldn't update trust policy for role {readonly_role_name_color}.")
                raise
            else:
                return role
    elif delete:
        if check_role_exists(color):
            try:
                if check_policy_exists(readonly_role_name_color, policy_name):
                    client.delete_role_policy(RoleName=readonly_role_name_color, PolicyName=policy_name)
                client.delete_role(RoleName=readonly_role_name_color)
                print(f"Deleted role {readonly_role_name_color}.")
            except botocore.exceptions.ClientError:
                print(f"Couldn't delete role {readonly_role_name_color}.")
                raise


def set_readonly_role_permissions_aws(resource, color = ''):
    root_path = Path(os.getcwd()).parents[1]
    iam_path = os.path.join(root_path, 'auto_policy_testing', 'iam', resource + '.json')
    with open(iam_path, 'r') as f:
        inline_policy = json.load(f)

    client = boto3.client('iam')
    readonly_role_name_color = f"{readonly_role_name}_{color}"
    response = client.put_role_policy(
        RoleName=readonly_role_name_color,
        PolicyName=policy_name,
        PolicyDocument=json.dumps(inline_policy)
    )