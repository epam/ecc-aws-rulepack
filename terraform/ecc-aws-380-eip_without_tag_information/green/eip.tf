resource "aws_eip" "this" {
    vpc      = true 
    tags = {
      CustodianRule    = "ecc-aws-380-eip_without_tag_information"
      ComplianceStatus = "Green"
    }
}