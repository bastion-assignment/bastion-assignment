aws_region              = "eu-west-1"
vpc_id                  = "vpc-0194dc38c18965d1a"
public_subnet_ids       = ["subnet-081f86c599474cbdf", "subnet-0da6e6de38c13a45c"]
private_subnet_ids      = ["subnet-00147e1e07bb7c654", "subnet-034c2e4c8e85568e5"]
environment             = "dev"
instance_type           = "t2.micro"
ami_name_pattern        = "bastion-host-ami-*"
allowed_ssh_cidr_blocks = ["xxx.iii.yyy.zzz/32"]
