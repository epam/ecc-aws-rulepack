resource "aws_route53_zone" "this" {
  name = "510-route53-zone-red.rule"
}

resource "aws_route53_record" "this3" {
  zone_id = aws_route53_zone.this.zone_id
  name    = aws_route53_zone.this.name
  type    = "MX"
  set_identifier = "510_record_red"
  ttl = 300
  records = ["10 mailhost1.example.com"]
  geolocation_routing_policy{
    country  = "UA"
  }
}
