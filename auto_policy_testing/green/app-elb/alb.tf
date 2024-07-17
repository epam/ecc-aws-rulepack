resource "aws_lb" "this1" {
  name                       = "${module.naming.resource_prefix.lb}-app1"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.this1.id, aws_security_group.this2.id]
  subnets                    = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_2_id ]
  internal                   = true
  drop_invalid_header_fields = true
  enable_deletion_protection = true
  desync_mitigation_mode     = "defensive"

  access_logs {
    bucket  = aws_s3_bucket.this.bucket
    enabled = true
  }
  depends_on = [
    aws_s3_bucket_policy.this
  ]
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }

  }
}

resource "aws_lb_listener" "this3" {
  load_balancer_arn = aws_lb.this1.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.this.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_wafregional_web_acl_association" "this" {
  resource_arn = aws_lb.this1.arn
  web_acl_id   = data.terraform_remote_state.common.outputs.wafregional_acl_id
}



resource "aws_lb" "this4" {
  name                       = "${module.naming.resource_prefix.lb}-app2"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.this1.id, aws_security_group.this2.id]
  subnets                    = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_2_id ]
}

resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = aws_lb.this4.arn
  web_acl_arn  = data.terraform_remote_state.common.outputs.wafv2_web_acl_arn
}

resource "null_resource" "this1" {
  triggers = {
    lb = aws_lb.this1.arn
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws elbv2 modify-load-balancer-attributes --load-balancer-arn ${self.triggers.lb} --attributes Key=deletion_protection.enabled,Value=false"
  }

  depends_on = [aws_lb.this1]
}

# resource "aws_lb_listener" "this4" {
#   load_balancer_arn = aws_lb.this4.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   certificate_arn   = aws_iam_server_certificate.this.arn

#   default_action {
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Fixed response content"
#       status_code  = "200"
#     }
#   }
# }

resource "aws_lb_listener" "this5" {
  load_balancer_arn = aws_lb.this4.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }

  }
}

# resource "aws_lb_listener_certificate" "this" {
#   listener_arn    = aws_lb_listener.this4.arn
#   certificate_arn = aws_acm_certificate.this.arn
# }