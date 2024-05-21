import os
import sys
import scan
import shutil
import report
import argparse
from pack_iam import pack_iam
import iam_role_aws
from terraform_infra import *


parser = argparse.ArgumentParser()

parser.add_argument('--cloud', choices=['GCP', 'Azure', 'AWS', 'OpenStack', 'Kubernetes'], help="Choose a Cloud",
                    type=str, required=True)
parser.add_argument('--infra_color', choices=['green', 'red'], help="Choose an infrastructure", type=str, required=True)
parser.add_argument('-l', '--resource_priority_list', type=str, help='resource priority list', required=True)
parser.add_argument('--base_dir', type=str, help='BASE_DIR path to the the rulepack repository ', required=True)
parser.add_argument('--output_dir', type=str, help='OUTPUT_DIR path to the the report results', required=True)
parser.add_argument('--regions', help="Please use ';' as separator", type=str)
parser.add_argument('--sa', help="Service Account for scanning", type=str, default="")
args = parser.parse_args()

resource_priority_list = args.resource_priority_list.split(',')
policy_execution_outputs = {}
RULEPACK_PATH = args.base_dir
RULEPACK_TESTING_PATH = os.path.join(RULEPACK_PATH, "auto_policy_testing")
OUTPUT_DIR = args.output_dir

def main():
    # Load yaml file names
    policies = sorted([file for file in os.listdir(os.path.join(RULEPACK_PATH, 'policies')) if
                       file.endswith('.yml') or file.endswith('.yaml')])
    tf_failed = {}
    if os.path.exists(OUTPUT_DIR):
        shutil.rmtree(OUTPUT_DIR)
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    sa = args.sa
    if args.cloud == "AWS":
        pack_iam()
        if args.sa:
            role = iam_role_aws.create_delete_readonly_role_aws(create=True, color=args.infra_color)
            sa = role.get("Role", {}).get("Arn", None)
    if args.cloud == "GCP":
        sa = args.sa
    tf_up_common_subprocess_result, tf_up_common_error = common_tf_up(RULEPACK_TESTING_PATH, args.infra_color)
    tf_up_subprocess_result = False
    if tf_up_common_subprocess_result:
        for resource in resource_priority_list:
            path = os.path.join(RULEPACK_TESTING_PATH, args.infra_color, resource)
            if args.cloud == "AWS" and args.sa:
                iam_role_aws.set_readonly_role_permissions_aws(resource, role.get("Role", {}).get("RoleName", None))
            tf_up_subprocess_result, tf_up_error = tf_up(resource, path, args.cloud, args.infra_color)
            if tf_up_subprocess_result:
                print("\nScan resources\n")
                try:
                    policy_execution_outputs.update(scan.custodian_run(
                        policy_execution_outputs,
                        base_dir=RULEPACK_PATH,
                        output_dir=OUTPUT_DIR,
                        cloud=args.cloud,
                        resource=resource,
                        path=path,
                        policies=policies,
                        regions=args.regions,
                        sa=sa if sa else None,
                        color=args.infra_color
                    ))
                except Exception as error:
                    print("An exception occurred:", error)
                    sys.exit(1)
            else:
                print("Error during 'terraform apply' for '" + resource + "': \n" + tf_up_error)
                tf_failed[resource] = "Error during 'terraform apply' for '" + resource + "': \n" + tf_up_error

            tf_down_subprocess_result, tf_down_error = tf_down(resource, path, args.cloud, args.infra_color)
            if not tf_down_subprocess_result:
                print("Error during 'terraform destroy' for '" + resource + "': \n" + tf_down_error)
                tf_failed[resource] = "Error during 'terraform destroy' for '" + resource + "': \n" + tf_down_error
    else:
        print("Error during 'terraform apply' for 'common_resources': \n" + tf_up_common_error)
        tf_failed['common_resources'] = "Error during 'terraform apply' for 'common_resources': \n" + tf_up_common_error

    tf_down_common_subprocess_result, tf_down_common_error = common_tf_down(RULEPACK_TESTING_PATH, args.infra_color)

    if not tf_down_common_subprocess_result:
        print("Error during 'terraform destroy' for 'common_resources': \n" + tf_down_common_error)
        tf_failed[
            'common_resources'] = "Error during 'terraform destroy' for 'common_resources': \n" + tf_down_common_error

    if tf_up_subprocess_result:
        report.create_report(
            policy_execution_outputs, output_dir=OUTPUT_DIR,
            infra_color=args.infra_color,
            cloud=args.cloud)

    if args.cloud == "AWS" and args.sa:
        iam_role_aws.create_delete_readonly_role_aws(delete=True, color=args.infra_color)

    with open(os.path.join(OUTPUT_DIR, '.tf_failed'), "w") as failed_file:
        for item, description in tf_failed.items():
            failed_file.write("Folder: " + item + "\n" + description + '-' * 30 + "\n\n")


if __name__ == "__main__":
    main()
