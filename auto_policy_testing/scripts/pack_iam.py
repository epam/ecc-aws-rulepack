import os
import re
import sys
import yaml
import json
from pathlib import Path

root_path = Path(os.getcwd()).parents[1]
tf_path = os.path.join(root_path, 'terraform')
policies_path = os.path.join(root_path, 'policies')
iam_path = os.path.join(root_path, 'auto_policy_testing', 'iam')

# list of policies that do not have neither green nor red terraform automated
exception_rules = {
    "aws": [],
    "gcp": [],
    "azure": []
}

template_full_resource_type_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Action": [],
            "Resource": "*"
        }
    ]
}


def read_yaml_file(filepath: str):
    content = {}
    with open(filepath) as yaml_file:
        content = yaml.safe_load(yaml_file)
    return content


def pack_iam():
    policies = sorted([file for file in os.listdir(policies_path) if file.endswith('.yml') or file.endswith('.yaml')])
    os.makedirs(iam_path, exist_ok=True)
    cloud = policies[0].split('-')[1]

    green_resource_types = os.listdir(os.path.join(root_path, 'auto_policy_testing', 'green'))
    green_resource_types.remove('common_resources')
    red_resource_types = os.listdir(os.path.join(root_path, 'auto_policy_testing', 'red'))
    red_resource_types.remove('common_resources')

    resource_types = []
    if sorted(green_resource_types) != sorted(red_resource_types):
        green_resource_types_set = set(green_resource_types)
        red_resource_types_set = set(red_resource_types)
        resource_types = list(green_resource_types_set.union(red_resource_types_set))
    else:
        resource_types = green_resource_types

    map_resource_policies = {key: [] for key in resource_types}

    for policy in policies:
        policy_content = read_yaml_file(os.path.join(policies_path, policy))
        policy_resource = policy_content['policies'][0].get('resource')
        policy_name = policy_content['policies'][0].get('name')
        for resource in map_resource_policies:
            if ((policy_resource.startswith(f'aws.{resource}') or policy_resource.startswith(resource))
                    and policy_name not in exception_rules[cloud]):
                map_resource_policies[resource].append(policy)
                break

    for resource, policies in map_resource_policies.items():
        full_resource_type_policy = template_full_resource_type_policy.copy()
        for policy in policies:
            policy_name = policy.replace(".yml", '').replace(".yaml", '')
            policy_id = policy.split("-")[2]
            tf_iam_path = os.path.join(tf_path, policy_name, 'iam', policy_id + '-policy.json')
            if os.path.isfile(tf_iam_path):
                with open(tf_iam_path, 'r') as iam_file:
                    iam_policy_content = json.load(iam_file)
                iam_policy_permissions = iam_policy_content.get("Statement")[0].get("Action")
                if type(iam_policy_permissions) == str:
                    if iam_policy_permissions not in full_resource_type_policy["Statement"][0]["Action"]:
                        full_resource_type_policy["Statement"][0]["Action"].append(iam_policy_permissions)
                elif type(iam_policy_permissions) == list:
                    for permission in iam_policy_permissions:
                        if permission not in full_resource_type_policy["Statement"][0]["Action"]:
                            full_resource_type_policy["Statement"][0]["Action"].append(permission)
            else:
                print("File does not exist: ", tf_iam_path)
                sys.exit(1)
        resource_type_iam_path = os.path.join(iam_path, resource + '.json')
        with open(resource_type_iam_path, "w") as iam_file:
            json.dump(full_resource_type_policy, iam_file)


if __name__ == "__main__":
    main()
