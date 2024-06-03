import os
import sys
import scan
import shutil
import report
import argparse
# from pack_iam import aws_pack_iam_policies_per_resource_type
import aws_iam_readonly_role
# from terraform_infra import *


parser = argparse.ArgumentParser()

parser.add_argument('--cloud', choices=['GCP', 'Azure', 'AWS', 'OpenStack', 'Kubernetes'], help="Choose a Cloud",
                    type=str, required=True)
parser.add_argument('--infra_color', choices=['green', 'red'], help="Choose an infrastructure", type=str, required=True)
parser.add_argument('--resource', type=str, help='resource to scan', required=True)
parser.add_argument('--base_dir', type=str, help='BASE_DIR path to the the rulepack repository ', required=True)
parser.add_argument('--output_dir', type=str, help='OUTPUT_DIR path to the the report results', required=True)
parser.add_argument('--regions', help="Please use ';' as separator", type=str)
parser.add_argument('--sa', help="For GCP - Service Account for scanning, for AWS - IAM role", type=str, default="")
args = parser.parse_args()

policy_execution_outputs = {}
RULEPACK_TESTING_PATH = os.path.join(args.base_dir, "auto_policy_testing")

def main():
    policies = sorted([file for file in os.listdir(os.path.join(args.base_dir, 'policies')) if
                       file.endswith('.yml') or file.endswith('.yaml')])

    if os.path.exists(args.output_dir):
        shutil.rmtree(args.output_dir)
    os.makedirs(args.output_dir, exist_ok=True)
    sa = args.sa
    if args.cloud == "AWS":
        if args.sa:
            role = aws_iam_readonly_role.create_delete_readonly_role_aws(create=True, color=args.infra_color)
            sa = role.get("Role", {}).get("Arn", None)
    if args.cloud == "GCP":
        sa = args.sa

    path = os.path.join(RULEPACK_TESTING_PATH, args.infra_color, args.resource)
    if args.cloud == "AWS" and args.sa:
        aws_iam_readonly_role.set_readonly_role_permissions_aws(args.resource, role.get("RoleName", None))

    print("\nScan resources\n")
    try:
        policy_execution_outputs.update(scan.custodian_run(
            policy_execution_outputs,
            base_dir=args.base_dir,
            output_dir=args.output_dir,
            cloud=args.cloud,
            resource=args.resource,
            path=path,
            policies=policies,
            regions=args.regions,
            sa=sa if sa else None,
            color=args.infra_color
        ))
    except Exception as error:
        print("An exception occurred:", error)
        sys.exit(1)

    report.create_report(
        policy_execution_outputs, output_dir=args.output_dir,
        infra_color=args.infra_color,
        cloud=args.cloud)

    if args.cloud == "AWS" and args.sa:
        aws_iam_readonly_role.create_delete_readonly_role_aws(delete=True, color=args.infra_color, role_name=role.get("RoleName", None))

if __name__ == "__main__":
    main()
