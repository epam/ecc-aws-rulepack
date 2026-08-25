output "hostedzone" {
  value = {
    hostedzone = "/hostedzone/${aws_route53_zone.this.zone_id}"
  }
}
