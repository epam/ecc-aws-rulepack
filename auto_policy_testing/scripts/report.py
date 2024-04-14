import os
import json
import regex
from scan import policy_in_exception

pattern_for_json_substring = regex.compile(r'\{(?:[^{}]|(?R))*\}')


def read_file(folder, sub_folder_name, filename):
    filepath = os.path.join(folder, sub_folder_name, filename)
    file = open(filepath, "r")
    content = file.read()
    file.close()
    return content


def read_json_file(folder, sub_folder_name, filename):
    filepath = os.path.join(folder, sub_folder_name, filename)
    content = {}
    with open(filepath) as json_file:
        content = json.load(json_file)
    return content


# Read results (custodian-run.log, metadata.json, resource.json) and put into array
def create_report(policy_execution_outputs: dict,
                  output_dir: str,
                  infra_color: str,
                  cloud: str):
    # Declare vars
    OUTPUT_DIR = output_dir
    detailed_report = []
    policy_execution_outputs_test = policy_execution_outputs.copy()

    for region in os.listdir(OUTPUT_DIR):
        current_path = os.path.join(OUTPUT_DIR, region)
        if os.path.isdir(current_path):
            for subfolder_name in os.listdir(current_path):
                if not os.path.isdir(os.path.join(current_path, subfolder_name)):
                    continue
                custodian_run = ""
                metadata = {}
                resources = []
                try:
                    custodian_run = read_file(current_path, subfolder_name, 'custodian-run.log')
                except Exception:
                    pass
                try:
                    metadata = read_json_file(current_path, subfolder_name, 'metadata.json')
                except Exception:
                    pass
                try:
                    resources = read_json_file(current_path, subfolder_name, 'resources.json')
                except Exception:
                    pass
                if custodian_run:
                    entity = {
                        "custodian-run": custodian_run,
                        "metadata": metadata,
                        "resources": resources,
                        "region": region
                    }
                    detailed_report.append(entity)
                    policy_name = metadata["policy"]["name"]
                    if policy_name in policy_execution_outputs.keys():
                        policy_execution_outputs.pop(policy_name)

    # Including results with errors
    for policy_name in policy_execution_outputs.keys():
        output = policy_execution_outputs[policy_name]['scan_result']
        policy_strings = pattern_for_json_substring.findall(output)
        policy = {"name": policy_name}
        if len(policy_strings) > 0:
            try:
                policy = json.loads(policy_strings[0])
            except Exception as e:
                pass
        if len(policy_strings) > 0:
            output = output.replace(policy_strings[0], '')
        output_list = output.split("\n")
        output_list = [output for output in output_list if output.strip() != ""]

        entity = {
            "custodian-run": "\n".join(output_list),
            "metadata": {'policy': policy},
            "resources": [],
            "errors": output_list
        }
        if 'region' in policy_execution_outputs[policy_name]:
            entity['region'] = policy_execution_outputs[policy_name]['region']

        detailed_report.append(entity)

    # Create report
    report = []
    for detailed_entity in detailed_report:
        detailed_custodian_run_log = detailed_entity["custodian-run"]
        detailed_metadata = detailed_entity["metadata"]
        detailed_resources = detailed_entity["resources"]
        detailed_errors = detailed_entity.get("errors", [])
        detailed_region = detailed_entity.get("region")

        policy = detailed_metadata["policy"]

        if policy_in_exception(policy.get("name", ""), cloud, infra_color):
            continue
        # policy_resource = policy.get("resource", "")
        # policy_metadata = policy.get("metadata", {})
        # report_fields = policy_metadata.get("report_fields")
        if detailed_custodian_run_log.find("ERROR") > -1:
            run_result = "Errors were found"
            detailed_errors = detailed_custodian_run_log
        else:
            run_result = "No errors"
        resources = detailed_resources.copy()
        # try:
        #     key_report = report_fields[0] if report_fields else None
        #     if key_report:
        #         detailed_resources = sorted(detailed_resources, key=lambda d: d[key_report])
        # except Exception:
        #     pass
        # for detailed_resource in detailed_resources:
        #     resources.append(detailed_resource)
            # resource = {}
            # for key in detailed_resource:
                # # if report_fields:
                # #     if key in report_fields:
                # #         resource[key] = detailed_resource.get(key)
                # #     continue
                # current_resource = detailed_resource[key]
                # if isinstance(current_resource, (str, int, float)):
                #     resource[key] = current_resource
                # elif policy_resource.startswith("gcp."):
                #     if type(current_resource) is dict:
                #         for inner_key in current_resource.keys():
                #             resource[key + "_" + inner_key] = current_resource[inner_key]
                #     elif type(current_resource) is list:
                #         if len(current_resource) > 0 and type(current_resource[0]) is not dict:
                #             resource[key] = "\n".join(current_resource)
            # resources.append(resource if resource else detailed_resource)

        entity = {
            "policy_name": policy.get("name", ""),
            "description": policy.get("description", "no description"),
            "run_result": run_result,
            "resources #": len(resources),
            "region": detailed_region,
            "resources": resources,
            "errors": [detailed_errors]
        }
        # add errors if resource was not found in the custodian scan results
        resource_found = False
        tf_resource_name_status = {}
        tf_resource_id = policy_execution_outputs_test[entity['policy_name']]['resource_id']

        with open(cloud.lower() + '_map_report_fields.json', 'r') as file:
            map_report_fields = json.load(file)
        resource_field = map_report_fields[policy_execution_outputs_test[entity['policy_name']]['policy_resource']]
        resource_field_value = ""

        # 1 report field && 1 infra
        if isinstance(tf_resource_id, str):
            for resource in entity["resources"]:
                if len(resource_field) > 1:
                    entity["errors"].append("ERROR - Resource type has multiple report fields, but in terraform output given only one!")
                    # resource_field_value = {r: resource[r] for r in resource_field}
                else:
                    resource_field_value = resource[resource_field[0]]
                    if tf_resource_id == resource_field_value and tf_resource_id:
                        tf_resource_name_status = {tf_resource_id: True}
                        resource_found = all(value is True for value in tf_resource_name_status.values())
                        break
                    else:
                        tf_resource_name_status = {tf_resource_id: False}
                    resource_found = all(value is True for value in tf_resource_name_status.values())

        # if 1 or more report fields && multiple infra
        elif isinstance(tf_resource_id, list):
            # if 1 report field && multiple infra
            if isinstance(tf_resource_id[0], str):
                tf_resource_ids = tf_resource_id.copy()
                tf_resource_name_status = {r: False for r in tf_resource_id}
                for resource in entity["resources"]:
                    if len(resource_field) > 1:
                        entity["errors"].append("ERROR - Resource type has multiple report fields, but in terraform output given only one!")
                        # resource_field_value = {r: resource[r] for r in resource_field}
                    else:
                        resource_field_value = resource[resource_field[0]]
                    for tf_resource in tf_resource_ids:
                        if isinstance(resource_field_value, str):
                            if tf_resource == resource_field_value and tf_resource:
                                tf_resource_name_status[tf_resource] = True
                                tf_resource_ids.remove(tf_resource)
                                break
                        else:
                            entity["errors"].append("ERROR - Wrong terraform output format, output resource id must be string!")
                    if all(value is True for value in tf_resource_name_status.values()):
                        break
                resource_found = all(value is True for value in tf_resource_name_status.values())

            # if multiple report fields && multiple infra
            elif isinstance(tf_resource_id[0], dict):
                tf_resource_name_status = []
                for res in tf_resource_id:
                    temp_dict = {}
                    for tf_rep_f, tf_res_id in res.items():
                        temp_dict[tf_rep_f] = {tf_res_id: False}
                    tf_resource_name_status.append(temp_dict)
                for resource in entity["resources"]:
                    resource_field_values = {}
                    for resource_field_name in resource_field:
                        resource_field_values[resource_field_name] = resource[resource_field_name]
                    for tf_res in tf_resource_name_status:
                        if not any(any(sub_dict.values()) for sub_dict in tf_res.values()) and not all(all(sub_dict.values()) for sub_dict in tf_res.values()):
                            for r_field, r_id in resource_field_values.items():
                                if r_id in tf_res.get(r_field, {}):
                                    tf_res[r_field][r_id] = True

                    resource_found = all(all(sub_dict.values()) for dict_ in tf_resource_name_status for sub_dict in dict_.values())
                    if resource_found:
                        break
                resource_found = all(all(sub_dict.values()) for dict_ in tf_resource_name_status for sub_dict in dict_.values())

            else:
                entity["errors"].append("ERROR - Wrong terraform output format!")

        # if multiple report fields and one infra
        elif isinstance(tf_resource_id, dict):
            if len(resource_field) > 1:
                if isinstance(list(tf_resource_id.values())[0], str):
                    tf_resource_name_status = {report_field: {tf_resource_id: False} for report_field, tf_resource_id in tf_resource_id.items()}
                    resource_field_values = {}
                    for resource in entity["resources"]:
                        if not any(any(sub_dict.values()) for sub_dict in tf_resource_name_status.values()) and not all(all(sub_dict.values()) for sub_dict in tf_resource_name_status.values()):
                            for resource_field_name in resource_field:
                                resource_field_values[resource_field_name] = resource[resource_field_name]
                            for r_field, r_id in resource_field_values.items():
                                if r_id in tf_resource_name_status.get(r_field, {}):
                                    tf_resource_name_status[r_field][r_id] = True
                                    resource_found = all(all(v.values()) for v in tf_resource_name_status.values())
                            if resource_found:
                                break
                    resource_found = all(all(v.values()) for v in tf_resource_name_status.values())
                else:
                    entity["errors"].append("ERROR - Wrong terraform output format!")
            else:
                entity["errors"].append("ERROR - Resource type has one report field, but in terraform output given multiple!")
        else:
            entity["errors"].append("ERROR - Wrong terraform output format, it must be one of str, list, or dict!")

        if infra_color == "red":
            if not resource_found and tf_resource_id:
                if isinstance(tf_resource_name_status, dict):
                    if all(isinstance(sub_dict, bool) for sub_dict in tf_resource_name_status.values()):
                        not_found_resources = [k for k, v in tf_resource_name_status.items() if v is False]
                        entity["errors"].append("ERROR - Error while testing found results.\n"
                                            f"The created terraform {infra_color} resource ({', '.join(not_found_resources)}) was not found in the custodian scan results")
                    elif all(isinstance(sub_dict, dict) for sub_dict in tf_resource_name_status.values()):
                        if not all(all(sub_dict.values()) for sub_dict in tf_resource_name_status.values()):
                            entity["errors"].append("ERROR - Error while testing found results.\n"
                                                    f"The created terraform {infra_color} resource ({', '.join([key for sub_dict in tf_resource_name_status.values() for key in sub_dict.keys()])}) was not found in the custodian scan results")

                elif isinstance(tf_resource_name_status, list):
                    for element in tf_resource_name_status:
                        if not all(all(sub_dict.values()) for sub_dict in element.values()):
                            entity["errors"].append("ERROR - Error while testing found results.\n"
                                                    f"The created terraform {infra_color} resource ({', '.join([key for sub_dict in element.values() for key in sub_dict.keys()])}) was not found in the custodian scan results")

        elif infra_color == "green":
            if isinstance(tf_resource_name_status, dict):
                if all(isinstance(sub_dict, bool) for sub_dict in tf_resource_name_status.values()):
                    if any(value is True for value in tf_resource_name_status.values()) and tf_resource_id:
                        found_resources = [k for k, v in tf_resource_name_status.items() if v is True]
                        entity["errors"].append("ERROR - Error while testing found results.\n"
                                        f"The created terraform {infra_color} resource ({', '.join(found_resources)}) was found in the custodian scan results")
                elif all(isinstance(sub_dict, dict) for sub_dict in tf_resource_name_status.values()):
                    if any(any(sub_dict.values()) for sub_dict in tf_resource_name_status.values()):
                        entity["errors"].append("ERROR - Error while testing found results.\n"
                                                f"The created terraform {infra_color} resource ({', '.join([key for sub_dict in tf_resource_name_status.values() for key in sub_dict.keys()])}) was found in the custodian scan results")


            elif isinstance(tf_resource_name_status, list):
                for element in tf_resource_name_status:
                    if any(any(sub_dict.values()) for sub_dict in element.values()):
                        entity["errors"].append("ERROR - Error while testing found results.\n"
                                                f"The created terraform {infra_color} resource ({', '.join([key for sub_dict in element.values() for key in sub_dict.keys()])}) was found in the custodian scan results")

        if not tf_resource_id:
            entity["errors"].append("ERROR - Error while testing found results.\n"
                                    f"OUTPUT variable was not found")
        report.append(entity)

    failed = list()
    sorted_report = sorted(report, key=lambda x: x["policy_name"])
    for entity in sorted_report:
        # Create failed file
        if entity["errors"] and entity["errors"] != [[]]:
            error_message = f'{entity["policy_name"]}:' + entity["region"] if entity["region"] != "default" else ""
            for error in entity["errors"]:
                if error:  
                    error_message += f'\n{error}\n'
            failed.append(error_message)

    with open(os.path.join(OUTPUT_DIR, '.failed'), "w") as failed_file:
        for item in failed:
            failed_file.write(item + "\n")
