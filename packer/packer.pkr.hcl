# Packer configuration file to build the custom AMI for the bastion host

packer {
  required_version = ">= 1.11.2"

  required_plugins {
    # Use the Amazon plugin to interact with AWS resources
    amazon = {
      version = "~> 1"
      source  = "github.com/hashicorp/amazon"
    }
    # Use the Ansible plugin to provision the instance with Ansible
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

# Define variables for AWS region, instance type, and SSH username
variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ssh_username" {
  type    = string
  default = "ec2-user"
}

# Configure the source AMI for building the bastion host
source "amazon-ebs" "bastion" {
  region                      = var.aws_region
  instance_type               = var.instance_type
  ssh_username                = var.ssh_username
  ami_name                    = "bastion-host-ami-${formatdate("YYYYMMDDHHmmss", timestamp())}"
  associate_public_ip_address = true

  # Filter to select the base AMI (Amazon Linux 2023)
  source_ami_filter {
    filters = {
      "virtualization-type" = "hvm"
      "name"                = "al2023-ami-2023.6.20241010.0-kernel-6.1-x86_64"
      "root-device-type"    = "ebs"
    }
    owners      = ["amazon"]
    most_recent = true
  }

  # Tag the AMI for identification
  tags = {
    Name        = "bastion-host-ami-${formatdate("YYYYMMDDHHmmss", timestamp())}"
    Environment = "Dev"
    Type        = "Bastion"
  }
}

# Define the build steps for the AMI
build {
  name    = "bastion-ami-build"
  sources = ["source.amazon-ebs.bastion"]

  # Use Ansible to provision the instance with the necessary configurations
  provisioner "ansible" {
    playbook_file = "./playbook.yml"
  }
}
