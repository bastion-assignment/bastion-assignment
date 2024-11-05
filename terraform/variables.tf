variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "The VPC ID where resources will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
  default     = "t2.micro"
}

variable "ami_name_pattern" {
  description = "Pattern to find the AMI built by Packer"
  type        = string
  default     = "bastion-host-ami-*"
}

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to access SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_bastion_cloudwatch_alarm" {
  description = "Set to true to create CloudWatch alarm for NLB unhealthy host count"
  type        = bool
  default     = true
}
