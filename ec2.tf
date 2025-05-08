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
  ami                         = "ami-051ec687ccec0d381"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_3a.id
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
resource "aws_instance" "app_3a" {
  ami                         = "ami-00dc6d07c0a114859"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_3a.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.app.id]
  user_data                   = file("./src/init.sh")

  tags = {
    Name = "${var.project}-${var.env}-ec2-app-3a"
  }
}

# ----------------------
# APサーバー2
# ----------------------
resource "aws_instance" "app_3c" {
  ami                         = "ami-00dc6d07c0a114859"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_3c.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.app.id]
  user_data                   = file("./src/init.sh")

  tags = {
    Name = "${var.project}-${var.env}-ec2-app-3c"
  }
}