import sys
import scan
import shutil
import report
import argparse
from pack_iam import pack_iam
import iam_role_aws
from terraform_infra import *
from logger import get_logger


logger = get_logger(__name__)

parser = argparse.ArgumentParser()

parser.add_argument('--cloud', choices=['GCP', 'Azure', 'AWS', 'OpenStack', 'Kubernetes'], help="Choose a Cloud",
                    type=str, required=True)
parser.add_argument('--infra_color', choices=['green', 'red'], help="Choose an infrastructure", type=str, required=True)
parser.add_argument('-l', '--resource_priority_list', type=str, help='resource priority list')
parser.add_argument('--base_dir', type=str, help='BASE_DIR path to the the rulepack repository ', required=True)
parser.add_argument('--output_dir', type=str, help='OUTPUT_DIR path to the the report results')
parser.add_argument('--regions', help="Please use ';' as separator", type=str)
parser.add_argument('--sa', help="Service Account for scanning", type=str, default="")
parser.add_argument('--ci_role_name', type=str, default='github_ci_ecc-aws-rulepack',
                    help='IAM role name trusted to assume the Custodian readonly role (AWS + --sa)')
parser.add_argument('--deploy_common_resources', help="Determines whether common resources need to be deployed before testing", choices=['yes', 'no'], default='yes')
parser.add_argument('--destroy_common_resources', help="Determines whether common resources need to be destroyed after testing", choices=['yes', 'no'], default='yes')
parser.add_argument('--clean_common_resources', action='store_true',
                    help='Only destroy common resources and exit (skip policy testing)')

args = parser.parse_args()

if not args.clean_common_resources:
    if not args.resource_priority_list:
        parser.error('-l/--resource_priority_list is required unless --clean_common_resources is set')
    if not args.output_dir:
        parser.error('--output_dir is required unless --clean_common_resources is set')

resource_priority_list = args.resource_priority_list.split(',') if args.resource_priority_list else []
policy_execution_outputs = {}
RULEPACK_PATH = args.base_dir
RULEPACK_TESTING_PATH = os.path.join(RULEPACK_PATH, "auto_policy_testing")
OUTPUT_DIR = args.output_dir
deploy_commons = True if args.deploy_common_resources == "yes" else False
destroy_commons = True if args.destroy_common_resources == "yes" else False

def clean_common_resources():
    """Destroy only common_resources terraform stack."""
    tf_failed = {}
    tf_down_common_subprocess_result, tf_down_common_error = common_tf_down(
        RULEPACK_TESTING_PATH, args.infra_color)

    if not tf_down_common_subprocess_result:
        logger.error("Error during 'terraform destroy' for 'common_resources': \n%s", tf_down_common_error)
        tf_failed['common_resources'] = (
            "Error during 'terraform destroy' for 'common_resources': \n" + tf_down_common_error
        )

    if args.output_dir:
        os.makedirs(args.output_dir, exist_ok=True)
        with open(os.path.join(args.output_dir, '.tf_failed'), "w") as failed_file:
            for item, description in tf_failed.items():
                failed_file.write("Folder: " + item + "\n" + description + '-' * 30 + "\n\n")

    if tf_failed:
        sys.exit(1)


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
            role = iam_role_aws.create_delete_readonly_role_aws(
                create=True, color=args.infra_color, ci_role_name=args.ci_role_name)
            sa = role.get("Role", {}).get("Arn", None)
    if args.cloud == "GCP":
        sa = args.sa
    if deploy_commons:
        tf_up_common_subprocess_result, tf_up_common_error = common_tf_up(RULEPACK_TESTING_PATH, args.infra_color)
    else:
        logger.info("Common resources will not be deployed")
        tf_up_common_subprocess_result = True
        tf_up_common_error = 'N/A'
    tf_up_subprocess_result = False
    if tf_up_common_subprocess_result:
        for resource in resource_priority_list:
            path = os.path.join(RULEPACK_TESTING_PATH, args.infra_color, resource)
            if args.cloud == "AWS" and args.sa:
                iam_role_aws.set_readonly_role_permissions_aws(resource, color=args.infra_color)
            tf_up_subprocess_result, tf_up_error = tf_up(resource, path, args.cloud, args.infra_color)
            if tf_up_subprocess_result:
                logger.info("Scan resources")
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
                    logger.exception("An exception occurred: %s", error)
                    sys.exit(1)
            else:
                logger.error("Error during 'terraform apply' for '%s': \n%s", resource, tf_up_error)
                tf_failed[resource] = "Error during 'terraform apply' for '" + resource + "': \n" + tf_up_error

            tf_down_subprocess_result, tf_down_error = tf_down(resource, path, args.cloud, args.infra_color)
            if not tf_down_subprocess_result:
                logger.error("Error during 'terraform destroy' for '%s': \n%s", resource, tf_down_error)
                tf_failed[resource] = "Error during 'terraform destroy' for '" + resource + "': \n" + tf_down_error
    else:
        logger.error("Error during 'terraform apply' for 'common_resources': \n%s", tf_up_common_error)
        tf_failed['common_resources'] = "Error during 'terraform apply' for 'common_resources': \n" + tf_up_common_error

    if destroy_commons:
        tf_down_common_subprocess_result, tf_down_common_error = common_tf_down(RULEPACK_TESTING_PATH, args.infra_color)

        if not tf_down_common_subprocess_result:
            logger.error("Error during 'terraform destroy' for 'common_resources': \n%s", tf_down_common_error)
            tf_failed[
                'common_resources'] = "Error during 'terraform destroy' for 'common_resources': \n" + tf_down_common_error
    else:
        logger.info("Common resources will not be destroyed")

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
    if args.clean_common_resources:
        logger.info("Cleaning common resources")
        clean_common_resources()
    else:
        main()
