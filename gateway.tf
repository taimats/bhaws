# ----------------------
# Internet Gateway
# ----------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

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
resource "aws_eip" "nat_3b" {
  vpc = true

  tags = {
    Name = "${var.project}-${var.env}-eip-nat-3b"
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
resource "aws_nat_gateway" "ptivate_3b" {
  subnet_id     = aws_subnet.public_3b.id
  allocation_id = aws_eip.nat_3b.id

  tags = {
    Name = "${var.project}-${var.env}-nat-3b"
  }
}