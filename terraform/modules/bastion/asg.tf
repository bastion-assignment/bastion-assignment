# Fetch the latest AMI
data "aws_ami" "bastion" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }
  owners = ["self"]
}

# Create a launch template for the bastion ASG
resource "aws_launch_template" "bastion_lt" {
  name_prefix   = "${var.environment}-bastion-lt-"
  image_id      = data.aws_ami.bastion.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.bastion_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.environment}-bastion"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create an ASG with one instance, in the private network
resource "aws_autoscaling_group" "bastion_asg" {
  name                = "${var.environment}-bastion-asg"
  max_size            = 1
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.bastion_lt.id
    version = "$Latest"
  }
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.environment}-bastion"
    propagate_at_launch = true
  }
}
