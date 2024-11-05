output "nlb_dns_name" {
  value       = module.bastion_host.nlb_dns_name
  description = "The DNS name of the bastion host Network Load Balancer"
}
