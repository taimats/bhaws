# ----------------------
# 踏み台サーバー用のKey Pair
# ----------------------
resource "aws_key_pair" "bastion" {
  key_name   = "${var.project}-${var.env}-key-pair-bastion"
  public_key = file("./src/bhapi-key-pair-bastion.pub")
}

# ----------------------
# 踏み台サーバー
# ----------------------
resource "aws_instance" "bastion" {
  ami                         = "ami-0265dc69e8de144d3"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_01.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = aws_key_pair.bastion.key_name

  tags = {
    Name = "${var.project}-${var.env}-ec2-bastion"
  }
}

# ----------------------
# APサーバー1
# ----------------------
resource "aws_instance" "app_01" {
  ami                         = "ami-0c2da9ee6644f16e5"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_01.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.app.id]
  user_data                   = file("./src/init.sh")

  tags = {
    Name = "${var.project}-${var.env}-ec2-app-01"
  }
}

# ----------------------
# APサーバー2
# ----------------------
resource "aws_instance" "app_02" {
  ami                         = "ami-0c2da9ee6644f16e5"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_02.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.app.id]
  user_data                   = file("./src/init.sh")

  tags = {
    Name = "${var.project}-${var.env}-ec2-app-02"
  }
}