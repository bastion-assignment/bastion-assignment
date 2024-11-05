resource "aws_lb" "nlb" {
  name                             = "${var.environment}-bastion-nlb"
  load_balancer_type               = "network"
  subnets                          = var.public_subnet_ids
  security_groups                  = [aws_security_group.nlb_sg.id]
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.environment}-bastion-nlb"
  }
}

resource "aws_lb_target_group" "nlb_tg" {
  name        = "${var.environment}-bastion-tg"
  port        = 22
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol            = "TCP"
    port                = "22"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
    interval            = 30
  }

  tags = {
    Name = "${var.environment}-bastion-tg"
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.bastion_asg.name
  lb_target_group_arn    = aws_lb_target_group.nlb_tg.arn
}

