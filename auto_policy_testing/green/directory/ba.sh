#!/bin/bash
set -e

SECURITY_GROUP_ID="sg-06309cf09c4be9423"

RULE_IDS=$(aws ec2 describe-security-group-rules  --filters Name="group-id",Values="$SECURITY_GROUP_ID" --query 'SecurityGroupRules[?CidrIpv4==`0.0.0.0/0` && IsEgress==`false`]'.SecurityGroupRuleId --output text)

for RULE_ID in $RULE_IDS
do
    OLD_RULE=$(aws ec2 describe-security-group-rules --security-group-rule-ids  $RULE_ID --output json --query "SecurityGroupRules[0].{IpProtocol:IpProtocol,FromPort:FromPort,ToPort:ToPort,CidrIpv4:CidrIpv4}")
    UPD_RULE=$(echo $OLD_RULE | sed 's|"0.0.0.0/0"|"10.0.2.0/24"|g')
    aws ec2 modify-security-group-rules --group-id $SECURITY_GROUP_ID --security-group-rules "[{\"SecurityGroupRuleId\": \"$RULE_ID\",\"SecurityGroupRule\": $UPD_RULE}]"
done