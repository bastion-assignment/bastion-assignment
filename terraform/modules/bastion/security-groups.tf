# Security group for the bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "${var.environment}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id
  # Allow SSH from allowed CIDR blocks
  ingress {
    description = "Allow SSH from allowed CIDR blocks"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }
  # Allow SSH from the NLB security group (for health checks)
  ingress {
    description     = "Allow SSH from the NLB SG (Healthchecks)"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.nlb_sg.id]
  }
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-bastion-sg"
  }
}

# Security group for the Network Load Balancer
resource "aws_security_group" "nlb_sg" {
  name        = "${var.environment}-bastion-nlb-sg"
  description = "Security group for the NLB"
  vpc_id      = var.vpc_id

  # Allow SSH from allowed CIDR blocks
  ingress {
    description = "Allow SSH from allowed CIDR blocks"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }
  # Allow inbound ICMP traffic
  ingress {
    description = "Allows inbound ICMP traffic to support MTU or Path MTU Discovery"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow all outbound traffic

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-nlb-sg"
  }
}
