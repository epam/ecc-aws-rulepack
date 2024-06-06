import yaml
import pathlib
import os
import subprocess
import sys
import time
import timer
import exception_rules
from terraform_infra import output


def read_yaml_file(filepath: str):
    content = {}
    with open(filepath) as yaml_file:
        content = yaml.safe_load(yaml_file)
    return content


def policy_in_exception(policy_name, cloud, color):
    except_rules = getattr(exception_rules, cloud)
    if policy_name in except_rules.get(color, []):
        return True
    else:
        return False


@timer.time_decorator
def custodian_run(policy_execution_outputs: dict,
                  base_dir: str,
                  output_dir: str,
                  cloud: str,
                  resource: str,
                  path: str,
                  policies: list,
                  color: str,
                  sa: str = None,
                  regions: str = None,
                  session_policy_file: str = None):

    # Declare directories
    POLICY_DIR = os.path.join(base_dir, 'policies')
    OUTPUT_DIR = output_dir
    REGIONS = regions
    CLOUD = cloud
    print(f"'{resource}' policies", flush=True)

    if not REGIONS:
        REGIONS = os.getenv("AWS_DEFAULT_REGION")

    # Run yaml policies
    print("The cloud is " + CLOUD)
    if CLOUD != 'aws':
        REGIONS = 'default'
    elif not REGIONS:
        print('Please use --regions param or setup the AWS_DEFAULT_REGION environment variable')
        sys.exit(1)
    regions = REGIONS.split(';')
    if resource in getattr(exception_rules, cloud).get("sleep_before_scan", []):
        time.sleep(180)
    for region in regions:
        region_param = '--region=' + region if region != "default" else ""
        for policy in policies:
            try:
                policy_content = read_yaml_file(os.path.join(POLICY_DIR, policy))
                policy_resource = policy_content['policies'][0].get('resource')
                if (policy_resource.startswith(f'aws.{resource}')
                        or policy_resource.startswith(f'gcp.{resource}')
                        or policy_resource.startswith(f'azure.{resource}')
                        or policy_resource.startswith(resource)):
                    if policy_in_exception(policy.split('.')[0], cloud, color):
                        continue
                    time.sleep(5)
                    command = (f"custodian run {os.path.join(POLICY_DIR, policy)} --dry-run --output-dir={os.path.join(OUTPUT_DIR, region)} \
                               --cache-period=0 {region_param if region_param else ''} \
                               {f'--assume {sa}'  if sa and CLOUD in ['gcp','aws'] else ''} \
                               {f'--session-policy {session_policy_file}'  if CLOUD == 'aws' else ''} \
                               ")
                    process = subprocess.Popen([command], shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
                    process.wait()
                    policy_resource = policy_resource.split('.')[1] if "." in policy_resource else policy_resource
                    cloud_resource_id = output(path, policy_name=policy.split('.')[0], resource=policy_resource)
                    policy_execution_outputs[policy.split('.')[0]] = {'scan_result': process.stdout.read().decode('utf-8'),
                                                                      'resource_id': cloud_resource_id,
                                                                      'policy_resource': policy_resource}
                    if region != "default":
                        policy_execution_outputs[policy.split('.')[0]]['region'] = region

                    print(f"processed {policy} policy")
            except Exception as error:
                print(f"An exception occurred with policy {policy}:", error)
                sys.exit(1)
    return policy_execution_outputs
