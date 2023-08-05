# Before deploying resources (registering domain) edit 'register-domain.json' file, enter valid values
# After deploying the domain name, you should verify your email address. After you've verified it, it takes about 16-20 minutes to register it, you'll be notified at email that registration succeeded.

resource "null_resource" "this" {

  provisioner "local-exec" {
    command = "aws route53domains register-domain --cli-input-json file://register-domain.json"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws route53domains delete-domain --domain-name ${local.domain_name}; aws  route53 delete-hosted-zone --id ${local.domain_name}"
    interpreter = ["/bin/bash", "-c"]
  }
}

locals {
  domain_name = "128-domain-green.click"
}