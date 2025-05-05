# ----------------------
# Internet Gateway
# ----------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main

  tags = {
    Name = "${var.project}-${var.env}-igw"
  }
}

# ----------------------
# Elastic IP
# ----------------------
resource "aws_eip" "nat_3a" {
  vpc = true

  tags = {
    Name = "${var.project}-${var.env}-eip-nat-3a"
  }
}
resource "aws_eip" "nat_3c" {
  vpc = true

  tags = {
    Name = "${var.project}-${var.env}-eip-nat-3c"
  }
}

# ----------------------
# NAT Gateway
# ----------------------
resource "aws_nat_gateway" "ptivate_3a" {
  subnet_id     = aws_subnet.public_3a.id
  allocation_id = aws_eip.nat_3a.id

  tags = {
    Name = "${var.project}-${var.env}-nat-3a"
  }
}
resource "aws_nat_gateway" "ptivate_3c" {
  subnet_id     = aws_subnet.public_3c.id
  allocation_id = aws_eip.nat_3c.id

  tags = {
    Name = "${var.project}-${var.env}-nat-3c"
  }
}