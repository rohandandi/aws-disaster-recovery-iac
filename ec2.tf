data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "web_az1" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  credit_specification {
    cpu_credits = "standard"
  }

  subnet_id              = aws_subnet.public_az1.id
  vpc_security_group_ids = [aws_security_group.web.id]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl enable httpd
              systemctl start httpd

              echo "<h1>Disaster Recovery Project - Web Server AZ1</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "web-server-az1"
  }
}

resource "aws_instance" "web_az2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  credit_specification {
    cpu_credits = "standard"
  }

  subnet_id              = aws_subnet.public_az2.id
  vpc_security_group_ids = [aws_security_group.web.id]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd
              systemctl enable httpd
              systemctl start httpd

              echo "<h1>Disaster Recovery Project - Web Server AZ2</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "web-server-az2"
  }
}