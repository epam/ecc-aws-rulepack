locals {
  aws_region_az_ids = {
    "us-east-1" = {
      name = "US East (N. Virginia)"
      azs  = ["use1-az2", "use1-az4", "use1-az6"]
    }
    "us-west-2" = {
      name = "US West (Oregon)"
      azs  = ["usw2-az1", "usw2-az2", "usw2-az3"]
    }
    "ap-south-1" = {
      name = "Asia Pacific (Mumbai)"
      azs  = ["aps1-az1", "aps1-az2", "aps1-az3"]
    }
    "ap-northeast-2" = {
      name = "Asia Pacific (Seoul)"
      azs  = ["apne2-az1", "apne2-az3"]
    }
    "ap-southeast-1" = {
      name = "Asia Pacific (Singapore)"
      azs  = ["apse1-az1", "apse1-az2"]
    }
    "ap-southeast-2" = {
      name = "Asia Pacific (Sydney)"
      azs  = ["apse2-az1", "apse2-az3"]
    }
    "ap-northeast-1" = {
      name = "Asia Pacific (Tokyo)"
      azs  = ["apne1-az1", "apne1-az4"]
    }
    "ca-central-1" = {
      name = "Canada (Central)"
      azs  = ["cac1-az1", "cac1-az2"]
    }
    "eu-central-1" = {
      name = "Europe (Frankfurt)"
      azs  = ["euc1-az2", "euc1-az3"]
    }
    "eu-west-1" = {
      name = "Europe (Ireland)"
      azs  = ["euw1-az1", "euw1-az2", "euw1-az3"]
    }
    "eu-west-2" = {
      name = "Europe (London)"
      azs  = ["euw2-az2", "euw2-az3"]
    }
    "eu-west-3" = {
      name = "Europe (Paris)"
      azs  = ["euw3-az1", "euw3-az2", "euw3-az3"]
    }
    "sa-east-1" = {
      name = "South America (São Paulo)"
      azs  = ["sae1-az1", "sae1-az3"]
    }
    "af-south-1" = {
      name = "Africa (Cape Town)"
      azs  = ["afs1-az1", "afs1-az2", "afs1-az3"]
    }
    "il-central-1" = {
      name = "Israel (Tel Aviv)"
      azs  = ["ilc1-az1", "ilc1-az2", "ilc1-az3"]
    }
    "us-gov-west-1" = {
      name = "AWS GovCloud (US-West)"
      azs  = ["usgw1-az1", "usgw1-az2", "usgw1-az3"]
    }
    "us-gov-east-1" = {
      name = "AWS GovCloud (US-East)"
      azs  = ["usge1-az1", "usge1-az2", "usge1-az3"]
    }
  }
}
