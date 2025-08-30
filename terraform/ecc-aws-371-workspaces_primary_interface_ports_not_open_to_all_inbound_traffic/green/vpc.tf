resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "this1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone_id       = "use1-az2"
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "this2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.2.0/24"
  availability_zone_id    = "use1-az4"
  map_public_ip_on_launch = "true"
}

resource "aws_security_group" "this" {
  name   = "workstation_security_group"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "this2" {
  name   = "workstation_security_group2"
  vpc_id = aws_vpc.this.id


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks      = [aws_vpc.this.cidr_block]
    security_groups   = [aws_security_group.this.id]
  }

}

resource "aws_security_group" "this3" {
  name   = "workstation_security_group3"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 222
    to_port     = 222
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self = true 
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "udp"
    security_groups  = [aws_security_group.this.id]
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this1.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "this2" {
  subnet_id      = aws_subnet.this2.id
  route_table_id = aws_route_table.this.id
}

/*
Automates these steps:
To attach created security groups:
1. Go to https://us-east-1.console.aws.amazon.com/workspaces/home?region=us-east-1#directories:directories
2. Note VPC of the created Directory
3. Go to https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#NIC:
4. Filter network interfaces using noted VPC ID.
5. Select the Network interface which has the following description "Created By Amazon Workspaces for AWS Account ID"
6. Click "Actions" and "Change security groups".
7. Attach security groups that start with "workstation_security_group". Click "Add security group".
8. Click "Save".
*/

# Data source to find WorkSpaces network interfaces
data "aws_network_interfaces" "workspaces_enis" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.this.id]
  }
  
  filter {
    name   = "description"
    values = ["Created By Amazon Workspaces for AWS Account ID*"]
  }
  
  depends_on = [aws_workspaces_workspace.this]
}

# List of security group IDs to attach
locals {
  workstation_security_group_ids = [
    aws_security_group.this.id,
    aws_security_group.this2.id,
    aws_security_group.this3.id
  ]
}

# Attach security groups to WorkSpaces network interfaces
resource "aws_network_interface_sg_attachment" "workspaces_sg_attachment" {
  count                = length(data.aws_network_interfaces.workspaces_enis.ids) * length(local.workstation_security_group_ids)
  network_interface_id = data.aws_network_interfaces.workspaces_enis.ids[count.index % length(data.aws_network_interfaces.workspaces_enis.ids)]
  security_group_id    = local.workstation_security_group_ids[floor(count.index / length(data.aws_network_interfaces.workspaces_enis.ids))]
  
  depends_on = [
    aws_workspaces_workspace.this,
    data.aws_network_interfaces.workspaces_enis
  ]
}

output "workspaces_enis_debug" {
  value = {
    ids_found = data.aws_network_interfaces.workspaces_enis.ids
    count     = length(data.aws_network_interfaces.workspaces_enis.ids)
  }
}