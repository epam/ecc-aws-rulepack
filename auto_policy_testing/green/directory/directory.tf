
resource "aws_directory_service_directory" "this" {
  name     = "${module.naming.resource_prefix.directory}.com"
  password = "#S1ncerely"
  size     = "Small"

  vpc_settings {
    vpc_id = data.terraform_remote_state.common.outputs.vpc_id
    subnet_ids = [
      data.terraform_remote_state.common.outputs.vpc_subnet_1_id,
      data.terraform_remote_state.common.outputs.vpc_subnet_3_id
    ]
  }
}

resource "null_resource" "this" {
  depends_on = [
    aws_directory_service_directory.this
  ]
  triggers = {
    sg = aws_directory_service_directory.this.security_group_id
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
set -e

SECURITY_GROUP_ID=${self.triggers.sg}

RULE_IDS=$(aws ec2 describe-security-group-rules  --filters Name="group-id",Values="$SECURITY_GROUP_ID" --query 'SecurityGroupRules[?CidrIpv4==`0.0.0.0/0` && IsEgress==`false`]'.SecurityGroupRuleId --output text)

for RULE_ID in $RULE_IDS
do
    OLD_RULE=$(aws ec2 describe-security-group-rules --security-group-rule-ids  $RULE_ID --output json --query "SecurityGroupRules[0].{IpProtocol:IpProtocol,FromPort:FromPort,ToPort:ToPort,CidrIpv4:CidrIpv4}")
    UPD_RULE=$(echo $OLD_RULE | sed 's|"0.0.0.0/0"|"10.0.2.0/24"|g')
    aws ec2 modify-security-group-rules --group-id $SECURITY_GROUP_ID --security-group-rules "[{\"SecurityGroupRuleId\": \"$RULE_ID\",\"SecurityGroupRule\": $UPD_RULE}]"
done
EOF
  }
}