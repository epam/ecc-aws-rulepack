locals {
  default_tags = merge(
    {
      ResourceType     = var.resource_type
      ComplianceStatus = var.status
      Owner            = "${var.project_name}-ci"
    }
  )
  compliance_status = lower(var.status)
  suffix            = "autotest"
}
