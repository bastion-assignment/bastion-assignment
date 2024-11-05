output "nlb_dns_name" {
  value       = module.bastion_host.nlb_dns_name
  description = "The DNS name of the bastion host Network Load Balancer"
}

output "sns_cloudwatch_alarm_topic" {
  value       = module.bastion_host.sns_cloudwatch_alarm_topic
  description = "The ARN of the cloudwatch SNS alarm topic"
}

