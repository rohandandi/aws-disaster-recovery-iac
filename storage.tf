resource "aws_ebs_volume" "data_az1" {
  availability_zone = aws_subnet.public_az1.availability_zone
  size              = 8
  type              = "gp3"

  tags = {
    Name = "dr-data-volume-az1"
  }
}

resource "aws_ebs_volume" "data_az2" {
  availability_zone = aws_subnet.public_az2.availability_zone
  size              = 8
  type              = "gp3"

  tags = {
    Name = "dr-data-volume-az2"
  }
}

resource "aws_volume_attachment" "data_az1" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data_az1.id
  instance_id = aws_instance.web_az1.id
}

resource "aws_volume_attachment" "data_az2" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.data_az2.id
  instance_id = aws_instance.web_az2.id
}