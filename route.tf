# ----------------------
# Route Public
# ----------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-rt"
  }
}

resource "aws_route_table_association" "public_3a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_3a.id
}

resource "aws_route_table_association" "public_3b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_3b.id
}

resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# ----------------------
# Route Pprivate
# ----------------------
resource "aws_route_table" "private_3a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-rt-private-3a"
  }
}

resource "aws_route_table_association" "private_3a" {
  route_table_id = aws_route_table.private_3a.id
  subnet_id      = aws_subnet.private_3a.id
}

resource "aws_route" "nat_private_3a" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_3a.id
  nat_gateway_id         = aws_nat_gateway.ptivate_3a.id
}

resource "aws_route_table" "private_3b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-rt-private-3b"
  }
}

resource "aws_route_table_association" "private_3b" {
  route_table_id = aws_route_table.private_3b.id
  subnet_id      = aws_subnet.private_3b.id
}

resource "aws_route" "nat_private_3b" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_3b.id
  nat_gateway_id         = aws_nat_gateway.ptivate_3b.id
}