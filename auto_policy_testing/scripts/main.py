import os
import sys
import scan
import shutil
import report
import argparse

parser = argparse.ArgumentParser()

parser.add_argument('--cloud', choices=['gcp', 'azure', 'aws', 'OpenStack', 'Kubernetes'], help="Choose a Cloud",
                    type=str, required=True)
parser.add_argument('--infra_color', choices=['green', 'red'], help="Choose an infrastructure", type=str, required=True)
parser.add_argument('--resource', type=str, help='resource to scan', required=True)
parser.add_argument('--base_dir', type=str, help='BASE_DIR path to the the rulepack repository ', required=True)
parser.add_argument('--output_dir', type=str, help='OUTPUT_DIR path to the the report results', required=True)
parser.add_argument('--auto_test_dir', help='Full path to auto-test directory', type=str, required=True)
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

    if args.cloud == "aws":
        if not args.sa:
            print('Please use --sa param for AWS to set IAM role for Custodian scans')
            sys.exit(1)
        # session_policy_path = os.path.join(args.auto_test_dir, 'iam', args.resource + '.json')
        # if not os.path.exists(session_policy_path):
        #     print(f"Missing IAM policy for {args.resource} in {session_policy_path}")
        #     sys.exit(1)
    if args.cloud == "gcp":
        sa = args.sa

    path = os.path.join(RULEPACK_TESTING_PATH, args.infra_color, args.resource)

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
            sa=args.sa if args.sa else None,
            color=args.infra_color
            # session_policy_file=session_policy_path if 'session_policy_path' in locals() else None
        ))
    except Exception as error:
        print("An exception occurred:", error)
        sys.exit(1)

    report.create_report(
        policy_execution_outputs, output_dir=args.output_dir,
        infra_color=args.infra_color,
        cloud=args.cloud)

if __name__ == "__main__":
    main()
