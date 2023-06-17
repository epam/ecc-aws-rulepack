resource "aws_eip" "this" {
    vpc      = true 
    tags = {
      CustodianRule    = "ecc-aws-553-eip_without_tag_information"
      ComplianceStatus = "Green"
    }
}