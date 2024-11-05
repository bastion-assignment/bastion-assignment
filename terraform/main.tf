# Call the bastion_host module
module "bastion_host" {
  source = "./modules/bastion"

  vpc_id                  = var.vpc_id
  public_subnet_ids       = var.public_subnet_ids
  private_subnet_ids      = var.private_subnet_ids
  environment             = var.environment
  instance_type           = var.instance_type
  ami_name_pattern        = var.ami_name_pattern
  allowed_ssh_cidr_blocks = var.allowed_ssh_cidr_blocks
}
