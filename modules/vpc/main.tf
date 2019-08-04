# Internet VPC
resource "aws_vpc" "main" {
  cidr_block           = "${var.VPC_CIDR_BLOCK}"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags {
    Name = "main"
  }
}

# Subnets
resource "aws_subnet" "main-public-1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.PUBLIC_SUBNET, 0)}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}a"

  tags {
    Name = "main-public-1"
  }
}

resource "aws_subnet" "main-public-2" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.PUBLIC_SUBNET, 1)}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}b"

  tags {
    Name = "main-public-2"
  }
}

resource "aws_subnet" "main-public-3" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.PUBLIC_SUBNET, 2)}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}c"

  tags {
    Name = "main-public-3"
  }
}

resource "aws_subnet" "main-private-1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.PRIVATE_SUBNET, 0)}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}a"

  tags {
    Name = "main-private-1"
  }
}

resource "aws_subnet" "main-private-2" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.PRIVATE_SUBNET, 1)}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}b"

  tags {
    Name = "main-private-2"
  }
}

resource "aws_subnet" "main-private-3" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.PRIVATE_SUBNET, 2)}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}c"

  tags {
    Name = "main-private-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "main"
  }
}

# route tables
resource "aws_route_table" "main-public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-gw.id}"
  }

  tags {
    Name = "main-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = "${aws_subnet.main-public-1.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}

resource "aws_route_table_association" "main-public-2-a" {
  subnet_id      = "${aws_subnet.main-public-2.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}

resource "aws_route_table_association" "main-public-3-a" {
  subnet_id      = "${aws_subnet.main-public-3.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}

# Define the security group
resource "aws_security_group" "internal-secg" {
  name   = "${var.CLUSTER_NAME}-internal-secg"
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "internal-secg-rule" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.internal-secg.id}"
  source_security_group_id = "${aws_security_group.internal-secg.id}"
}

resource "aws_security_group" "external-secg" {
  name   = "${var.CLUSTER_NAME}-external-secg"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "external-secg-rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.external-secg.id}"
}
