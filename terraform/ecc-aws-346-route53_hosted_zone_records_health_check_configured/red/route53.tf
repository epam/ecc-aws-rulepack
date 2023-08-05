resource "aws_route53_zone" "this" {
  name = "346-route53-zone-red.rule"
}

resource "aws_route53_record" "this3" {
  zone_id = aws_route53_zone.this.zone_id
  name    = aws_route53_zone.this.name
  type    = "MX"
  set_identifier = "346_record_red"
  ttl = 300
  records = ["10 mailhost1.example.com"]
  geolocation_routing_policy{
    country  = "UA"
  }
}
