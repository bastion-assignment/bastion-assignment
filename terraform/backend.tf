# Configures the terraform backend to use S3 to store the state and a dynammodb table called `bastion-assignment-terraform-lock-table` to store the LockID. Comment out this section if you wish to run this code locally
terraform {
  backend "s3" {
    bucket         = "bastion-assignment-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "bastion-assignment-terraform-lock-table"
    encrypt        = true
  }
}
