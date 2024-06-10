#!/usr/bin/env python3.8


# Script creates a 'list_of_rules.csv' file with list of all rules and their 'description', 'service section', and 'category'.
# This file can be used to create a table in KB/Public Custodian info/List of Rules by cloud.
#
# Example:
#     python generate_list_of_rules.py --dir_to_rules "E:\\ecc-aws-rulepack\\policies" --output_dir "E:\\ecc-aws-rulepack" --file_name "List-of-Rules-by-AWS"
#
# --dir_to_rules and --output_dir options works only with absolute path

import os
import csv
import argparse
import encoded_meta_map as maps
from ruamel.yaml import YAML
from py_markdown_table.markdown_table import markdown_table
from collections import OrderedDict


def read_yaml_files(dir_to_rules, output_dir, file_name):
    markdown_file_path = os.path.join(output_dir, file_name)
    with open(markdown_file_path, "w", encoding='UTF8', newline="") as txt:
        yaml = YAML(pure=True)

        rules = [os.path.splitext(file)[0] for file in sorted(os.listdir(dir_to_rules))
                 if os.path.isfile(os.path.join(dir_to_rules, file))
                 and file.endswith('.yml')]
        table_data = []
        category_map = {v: k for k, v in maps.category_map.items()}
        service_section_map = {v: k for k, v in maps.service_section_map.items()}
        for rule_name in rules:
            rule_filepath = os.path.join(dir_to_rules, rule_name + '.yml')
            with open(rule_filepath, 'r', encoding="utf8") as rule:
                content = rule.read()
                policy = yaml.load(content).get('policies', [])
                description = str(policy[0]['description']).rstrip('\n')
                index = str(policy[0]['comment']).rstrip('\n')
                service_section = service_section_map.get(index[6:8])
                category = category_map.get(index[4:6])

                dict_data = OrderedDict(
                    [('Name', rule_name), ('Description', description), ('Service Section', service_section),
                     ('Category', category)])
                table_data.append(dict_data)

        markdown = markdown_table(table_data).set_params(quote=False, row_sep='markdown').get_markdown()
        txt.write(markdown)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate markdown table with full list of rules, its description and service section')
    parser.add_argument('--dir_to_rules', type=str, required=True, help='Path to the directory with rules (yaml files)')
    parser.add_argument('--output_dir', type=str, required=True, help='Path to the directory for markdown table output')
    parser.add_argument('--file_name', type=str, required=True, help='Markdown table name')

    args = parser.parse_args()
    dir_to_rules = args.dir_to_rules
    if not os.path.exists(dir_to_rules):
        raise FileNotFoundError(f'Directory with rules do not exists: {dir_to_rules}')
    output_dir = args.output_dir
    if not os.path.exists(output_dir):
        raise FileNotFoundError(f'Output directory do not exists: {output_dir}')
    file_name = args.file_name

    read_yaml_files(dir_to_rules, output_dir, file_name)