resource "aws_ebs_snapshot" "data_az1_backup" {
  volume_id   = aws_ebs_volume.data_az1.id
  description = "Disaster Recovery Backup - AZ1"

  tags = {
    Name = "dr-backup-az1"
  }
}

resource "aws_ebs_snapshot" "data_az2_backup" {
  volume_id   = aws_ebs_volume.data_az2.id
  description = "Disaster Recovery Backup - AZ2"

  tags = {
    Name = "dr-backup-az2"
  }
}