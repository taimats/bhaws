# ----------------------
# VPC
# ----------------------
resource "aws_vpc" "main" {
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "${var.project}-${var.env}-vpc"
  }
}

# ----------------------
# Public Subnet
# ----------------------
resource "aws_subnet" "public_3a" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "${var.region}a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.env}-subnet-public-3a"
  }
}

resource "aws_subnet" "public_3c" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "${var.region}c"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.env}-subnet-public-3c"
  }
}

# ----------------------
# Private Subnet
# ----------------------
resource "aws_subnet" "private_3a" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "${var.region}a"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project}-${var.env}-subnet-private-3a"
  }
}

resource "aws_subnet" "private_3c" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "${var.region}c"
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project}-${var.env}-subnet-private-3c"
  }
}