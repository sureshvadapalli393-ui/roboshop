resource "aws_instance" "terraform-first" {
  instance_type           = "t2.micro"
  ami                     = "ami-09c813fb71547fc4f"
  subnet_id     = "subnet-0c80d0bf9b4c73e6d"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name = "terraform "
  }
}

resource "aws_security_group" "allow_all" {
  name   = "allow"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alow"
  }
  

}