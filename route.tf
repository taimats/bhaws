# ----------------------
# Route Public
# ----------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-rt"
  }
}

resource "aws_route_table_association" "public_01" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_01.id
}

resource "aws_route_table_association" "public_02" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_02.id
}

resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# ----------------------
# Route Pprivate
# ----------------------
resource "aws_route_table" "private_01" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-rt-private-01"
  }
}

resource "aws_route_table_association" "private_01" {
  route_table_id = aws_route_table.private_01.id
  subnet_id      = aws_subnet.private_01.id
}

resource "aws_route" "nat_private_01" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_01.id
  nat_gateway_id         = aws_nat_gateway.ptivate_01.id
}

resource "aws_route_table" "private_02" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.env}-rt-private-02"
  }
}

resource "aws_route_table_association" "private_02" {
  route_table_id = aws_route_table.private_02.id
  subnet_id      = aws_subnet.private_02.id
}

resource "aws_route" "nat_private_02" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_02.id
  nat_gateway_id         = aws_nat_gateway.ptivate_02.id
}