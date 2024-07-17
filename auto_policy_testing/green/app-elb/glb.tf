resource "aws_lb" "this3" {
  name               = "${module.naming.resource_prefix.lb}-gw-1"
  load_balancer_type = "gateway"
  enable_deletion_protection = true
  subnets            = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_2_id ]
}

resource "null_resource" "this3" {
  triggers = {
    lb = aws_lb.this3.arn
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws elbv2 modify-load-balancer-attributes --load-balancer-arn ${self.triggers.lb} --attributes Key=deletion_protection.enabled,Value=false"
  }

  depends_on = [aws_lb.this3]
}