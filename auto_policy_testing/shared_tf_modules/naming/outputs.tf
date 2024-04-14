output "resource_prefix" {
  value = {
    cfn            = "${local.suffix}-${var.resource_type}-cfn-${local.compliance_status}"
    sns            = "${local.suffix}_${var.resource_type}_sns_${local.compliance_status}"
    kms_key        = "${local.suffix}_${var.resource_type}_kms_key_${local.compliance_status}"
    ami            = "${local.suffix}_${var.resource_type}_ami_${local.compliance_status}"
    ebs_volume     = "${local.suffix}_${var.resource_type}_ebs_volume_${local.compliance_status}"
    ebs_snapshot   = "${local.suffix}_${var.resource_type}_ebs_snapshot_${local.compliance_status}"
    security_group = "${local.suffix}_${var.resource_type}_sg_${local.compliance_status}"
    vpc            = "${local.suffix}_${var.resource_type}_vpc_${local.compliance_status}"
    ecr_repository = "${local.suffix}_${var.resource_type}_ecr_repository_${local.compliance_status}"
    lambda_function = "${local.suffix}_${var.resource_type}_function_${local.compliance_status}"
    iam_role        = "${local.suffix}_${var.resource_type}_role_${local.compliance_status}"
    iam_policy      = "${local.suffix}_${var.resource_type}_iam_policy_${local.compliance_status}"
    ec2_instance    = "${local.suffix}_${var.resource_type}_ec2_instance_${local.compliance_status}"
    apigwv2_stage   = "${local.suffix}_${var.resource_type}_apigwv2_stage_${local.compliance_status}"
    apigwv2         = "${local.suffix}_${var.resource_type}_apigwv2_${local.compliance_status}"
    cw_log_group    = "${local.suffix}_${var.resource_type}_log_group_${local.compliance_status}"
  }
}

output "default_tags" {
  value = local.default_tags
}