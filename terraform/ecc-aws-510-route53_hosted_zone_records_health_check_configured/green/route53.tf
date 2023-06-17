resource "aws_route53_zone" "this" {
  name = "510-route53-zone-green.rule"
}


resource "aws_route53_record" "this1" {
  zone_id = aws_route53_zone.this.zone_id
  name    = aws_route53_zone.this.name
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.this.website_domain
    zone_id                = aws_s3_bucket.this.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "this2" {
  zone_id         = aws_route53_zone.this.zone_id
  name            = aws_route53_zone.this.name
  type            = "AAAA"
  set_identifier  = "510_record_green"
  health_check_id = aws_route53_health_check.this.id
  ttl             = 300
  records         = ["1111::1111"]
  weighted_routing_policy {
    weight = 200
  }
}

resource "aws_route53_record" "this3" {
  zone_id         = aws_route53_zone.this.zone_id
  name            = aws_route53_zone.this.name
  type            = "MX"
  set_identifier  = "510_record_green"
  health_check_id = aws_route53_health_check.this.id
  ttl             = 300
  records         = ["10 mailhost1.example.com"]
  geolocation_routing_policy {
    country = "UA"
  }
}

resource "aws_route53_health_check" "this" {
  reference_name    = "510_health_check_green"
  ip_address        = "1.1.1.1"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "5"
  request_interval  = "30"
  disabled          = true
}