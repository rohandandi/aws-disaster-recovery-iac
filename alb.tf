resource "aws_lb_target_group" "web" {
  name     = "disaster-recovery-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.disaster_recovery.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "disaster-recovery-web-tg"
  }
}

resource "aws_lb_target_group_attachment" "web_az1" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web_az1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_az2" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web_az2.id
  port             = 80
}

resource "aws_lb" "web" {
  name               = "disaster-recovery-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.web.id
  ]

  subnets = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id
  ]

  tags = {
    Name = "disaster-recovery-alb"
  }
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

data "aws_vpc" "disaster_recovery" {
  filter {
    name   = "tag:Name"
    values = ["disaster-recovery-vpc"]
  }
}