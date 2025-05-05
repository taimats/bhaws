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

resource "aws_route_table_association" "public_3c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_3c.id
}

resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# ----------------------
# Route Pprivate
# ----------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-rt"
  }
}

resource "aws_route_table_association" "private_3a" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_3a.id
}

resource "aws_route_table_association" "private_3c" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private_3c.id
}

resource "aws_route" "nat_private_3a" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.ptivate_3a.id
}

resource "aws_route" "nat_private_3c" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.ptivate_3c.id
}