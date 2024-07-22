resource "aws_lb" "this2" {
  name               = "${module.naming.resource_prefix.lb}-net-1"
  internal           = true
  load_balancer_type = "network"
  enable_deletion_protection = true
  subnets            = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_2_id ]

  access_logs {
    bucket  = aws_s3_bucket.this.bucket
    enabled = true
  }
  depends_on = [
    aws_s3_bucket_policy.this
  ]
}

resource "aws_lb_target_group" "this2" {
  name     = "${module.naming.resource_prefix.lb}-tg-1"
  port     = 443
  protocol = "TCP"
  vpc_id   = data.terraform_remote_state.common.outputs.vpc_id
}

resource "aws_lb_listener" "this2" {
  load_balancer_arn = aws_lb.this2.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_iam_server_certificate.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this2.arn
  }
}

resource "null_resource" "this2" {
  triggers = {
    lb = aws_lb.this2.arn
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws elbv2 modify-load-balancer-attributes --load-balancer-arn ${self.triggers.lb} --attributes Key=deletion_protection.enabled,Value=false"
  }

  depends_on = [aws_lb.this2]
}