output "distribution" {
  value = {
    distribution = aws_cloudfront_distribution.this1.arn
    ecc-aws-012-use_secure_ciphers_in_cloudfront_distribution = [aws_cloudfront_distribution.this2.arn]
    ecc-aws-065-encrypted_connection_between_cloudfront_origin = [aws_cloudfront_distribution.this1.arn, aws_cloudfront_distribution.this2.arn]
    ecc-aws-103-cloudfront_web_distributions_use_custom_ssl_certificates = aws_cloudfront_distribution.this2.arn
    ecc-aws-295-use_secure_ssl_protocols_between_cloudfront_origin = [aws_cloudfront_distribution.this1.arn, aws_cloudfront_distribution.this2.arn]
    ecc-aws-478-cloudfront_sni_enabled = [aws_cloudfront_distribution.this1.arn, aws_cloudfront_distribution.this2.arn]
    ecc-aws-538-cloudfront_s3_origin_non_existent_bucket = [aws_cloudfront_distribution.this1.arn, aws_cloudfront_distribution.this2.arn]    
    ecc-aws-539-cloudfront_origin_access_control_enabled = [aws_cloudfront_distribution.this1.arn, aws_cloudfront_distribution.this2.arn]
  }
}
