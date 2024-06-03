import os
import json
import sys

import boto3
import random
import botocore
import argparse
from pathlib import Path

policy_name = 'custodian_readonly'


def check_role_exists(readonly_role_name_color):
    client = boto3.client('iam')
    try:
        response = client.get_role(RoleName=readonly_role_name_color)
        role_exists = True
    except client.exceptions.NoSuchEntityException:
        role_exists = False
    return role_exists


def remove_attached_policies(role_name):
    client = boto3.client('iam')
    policies = client.list_role_policies(RoleName=role_name).get('PolicyNames', [])
    for policy in policies:
        client.delete_role_policy(RoleName=role_name, PolicyName=policy)


def create_delete_readonly_role_aws(ci_role_name, readonly_role_name, create=False, delete=False, color=''):
    # if create:
    #     role_id = random.randint(1000, 9999)
    #     # role_name = f"{readonly_role_name}_{color}_{role_id}"
    #     readonly_role_name = f"{readonly_role_name}_{role_id}"

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
        if not check_role_exists(readonly_role_name):
            try:
                role = client.create_role(
                    RoleName=readonly_role_name, AssumeRolePolicyDocument=json.dumps(trust_policy)
                )
                print(f"Created role {readonly_role_name}")
            except botocore.exceptions.ClientError:
                print(f"Couldn't create role {readonly_role_name}")
                raise
            else:
                return role.get("Role", {})
        else:
            try:
                role = client.update_assume_role_policy(
                    RoleName=readonly_role_name, PolicyDocument=json.dumps(trust_policy)
                )
                print(f"Updated trust policy for role {readonly_role_name}")
            except botocore.exceptions.ClientError:
                print(f"Couldn't update trust policy for role {readonly_role_name}")
                raise
            else:
                return role.get("Role", {})
    elif delete:
        if check_role_exists(readonly_role_name):
            try:
                remove_attached_policies(readonly_role_name)
                # if check_policy_exists(readonly_role_name, policy_name):
                #     client.delete_role_policy(RoleName=readonly_role_name, PolicyName=policy_name)
                client.delete_role(RoleName=readonly_role_name)
                print(f"Deleted role {readonly_role_name}")
            except botocore.exceptions.ClientError:
                print(f"Couldn't delete role {readonly_role_name}")
                raise
        else:
            print(f"Couldn't find role '{readonly_role_name}'")
            raise


def set_readonly_permissions_for_resources(resource, role_name):
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


def set_readonly_permissions_global(role_name):
    root_path = Path(os.getcwd()).parents[1]
    iam_path_dir = os.path.join(root_path, 'iam')
    policies_files = [file for file in os.listdir(iam_path_dir) if file.endswith('.json')]

    for policy_file in policies_files:
        policy_file_path = os.path.join(iam_path_dir, policy_file)
        with open(policy_file_path, 'r') as f:
            inline_policy = json.load(f)

        client = boto3.client('iam')
        response = client.put_role_policy(
            RoleName=role_name,
            PolicyName=policy_name + policy_file.split('.')[0],
            PolicyDocument=json.dumps(inline_policy)
        )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--ci_exec_role_name', type=str, help='role name used to deploy resources from CI',
                        required=True)
    parser.add_argument('--ci_readonly_role_name', type=str, help='role name for scans', required=True)
    exclusive_group = parser.add_mutually_exclusive_group(required=False)
    exclusive_group.add_argument('--create', action='store_true')
    exclusive_group.add_argument('--delete', action='store_true')

    args = parser.parse_args()
    ci_exec_role_name = args.ci_exec_role_name.split('/')[-1]

    if args.ci_readonly_role_name:

        role = create_delete_readonly_role_aws(ci_exec_role_name, args.ci_readonly_role_name, create=args.create,
                                               delete=args.delete)
        if args.create:
            set_readonly_permissions_global(role.get("RoleName", None))
    else:
        print("Empty '--ci_readonly_role_name' argument value\n"
              "If the CI job was cancelled and creation of role wasn't performed, this behaviour is normal. "
              "No action is required")
        sys.exit(1)

if __name__ == "__main__":
    main()
