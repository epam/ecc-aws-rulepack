resource_priority_list='["s3", "v1", "ecr", "v3", "v4", "eni", "v5", "fcvsedv", "4re65"]'
cloud='aws'
not_parallel_resources="$(python -c "import exception_rules; print(exception_rules.$cloud.get('not-parallel',[]))")"
echo "parsed not par: $not_parallel_resources"

not_parallel_resources='["v5", "dfds", "eni", "ecr"]'

source resources_to_scan.sh

not_parallel_resources_to_scan="$(get_not_parallel_resources_to_scan "$not_parallel_resources" "$resource_priority_list")"
parallel_resources_to_scan="$(get_parallel_resources_to_scan "$not_parallel_resources" "$resource_priority_list")"

echo "$parallel_resources_to_scan"
echo "$not_parallel_resources_to_scan"