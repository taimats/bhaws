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
resource "aws_eip" "nat_01" {
  vpc = true

  tags = {
    Name = "${var.project}-${var.env}-eip-nat-01"
  }
}
resource "aws_eip" "nat_02" {
  vpc = true

  tags = {
    Name = "${var.project}-${var.env}-eip-nat-02"
  }
}

# ----------------------
# NAT Gateway
# ----------------------
resource "aws_nat_gateway" "ptivate_01" {
  subnet_id     = aws_subnet.public_01.id
  allocation_id = aws_eip.nat_01.id

  tags = {
    Name = "${var.project}-${var.env}-nat-01"
  }
}
resource "aws_nat_gateway" "ptivate_02" {
  subnet_id     = aws_subnet.public_02.id
  allocation_id = aws_eip.nat_02.id

  tags = {
    Name = "${var.project}-${var.env}-nat-02"
  }
}