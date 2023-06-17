resource "aws_iam_service_linked_role" "this" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "this" {
  domain_name = "elasticsearch-200-green"

  ebs_options {
    ebs_enabled = true
    volume_size = "10"
  }

  vpc_options {
    subnet_ids = [
      aws_subnet.this.id
    ]
  }
  depends_on = [aws_iam_service_linked_role.this]
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
}