# Bastion Assignment

## Implementation Considerations

### Packer/Ansible/Goss

In order to create the custom AMI, I used Packer and the Ansible provider to run the Ansible script inside the EC2 instance. I used Ansible to:

1. Install and enable the OpenSSH server service.
2. Install, enable, and configure the `iptables` service.
3. Install the GOSS executable on the machine.

Then I used the `file` provider to copy the `goss` yaml template file in the ec2 instance and the `shell` provider to run the `goss` tests. These initial tests include the default suite of checking that `openssh` is configured as expected and that the `iptables` service is running. Future tests could include to properly check the `iptables` service and if the specific rules are present and enabled.

For linting the Ansible code, I used the `ansible-lint` package. Regarding the Packer code, I decided to write in `hcl` instead of `json` since I found it easier to read and maintain compared to `json`, and more future-proof.

### Terraform Code

Since the end goal of the assignment is to generate a bastion instance with an NLB in front of it, I decided to bundle the whole solution into a Terraform module for better reusability.

I also manually created a simple VPC network with 2 private and 2 public subnets in the Ireland region (`eu-west-1`), one S3 bucket for the Terraform state, and one DynamoDB table for the Terraform LockID. 

If you desire to run Terraform locally and test the code, you might want to remove the `state.tf` file to have the state file locally (not recommended for production-grade Terraform code).

Finally, I have to note I used `terraform-fmt` to properly format the code, that `terraform-docs` to generate the respective docs for the terraform module I've created.

#### Security Considerations

In its recent releases, NLB now supports attaching security groups. I took advantage of this fact and created a security group for the NLB, allowing traffic only on port 22 and only from my own personal IP. The allowed IP CIDR is configurable, so you can set any IP you might want to.

I also created a security group for the ASG. This SG allows only incoming traffic from the NLB's security group on port 22. This is sufficient both for allowing incoming traffic from the desired IP(s) and for the NLB health check to work properly.

### Bonus Points

#### CloudWatch Metrics/Alerts

There were two possible approaches here:

1. Utilize the `cloudwatch-agent`, install it on the EC2 instance, and push metrics to CloudWatch. This could be the best solution since we can get statistics regarding the service itself and push them to CloudWatch. Because of the time constraints of this assignment, I decided not to implement the solution at the moment.

2. Create a CloudWatch Alarm based on the NLB's health check and create an alarm when the NLB's target is down, pushing the event to SNS. This is the approach I followed for the assignment, and I've added the respective code in the Terraform module to optionally enable the alert.

#### Networking with Other Instances in the Private Networks

There are multiple ways to properly enable communication from/to the bastion instance to other EC2 instances in the VPC. Depending on how strict you want to be, the first approach could be to add a rule to the respective SGs (both bastion's and other ASGs) and allow access to both private networks' CIDRs in the port range we would like.

A more fine-grained approach would be, instead of allowing the whole private networks' CIDRs, to only allow specific security groups with specific ports to communicate (as we did for NLB <-> ASGs security groups).

### Example Usage

Assuming all the respective components are installed (i.e., `terraform`, `packer`, `ansible`), and as mentioned in the assignment description, we have VPC and AWS CLI credentials configured, we should:

1. Go to the `packer` directory: `cd packer`
2. Run the Packer init command to initialize Packer and download the respective providers: `packer init packer.pkr.hcl`
3. Run the Packer build command to build the AMI: `packer build packer.pkr.hcl`
4. Go to the `terraform` directory: `cd ../terraform`
5. Update the respective Terraform variables according to your configuration in the `terraform.tfvars` file (VPC, private/public subnets, `allowed_ssh_cidr_blocks` to set your IP(s), select if you want to install the `CloudWatch` alarm)
6. Initialize Terraform: `terraform init`
7. Run Terraform Plan to see the resources that are going to be created: `terraform plan`
8. Run Terraform Apply to apply the changes: `terraform apply`
9. The Terraform code is going to output the NLB IP address and the optional SNS topic
10. To validate that NLB is running, you can test with netcat: `nc -v <NLB_IP_ADDRESS> 22`

**Notes:** I have not configured any SSH keys for the instance, since it was not a part of this assignment. If we would like to make such a configuration, we should add the respective public key(s) to the instance (through the `aws_key_pair` Terraform resource and updating the respective launch template), or through AMI creation (even though I would go with the AWS native option).
