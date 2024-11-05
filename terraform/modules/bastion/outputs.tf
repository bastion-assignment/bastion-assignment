output "nlb_dns_name" {
  value       = aws_lb.nlb.dns_name
  description = "The DNS name of the Network Load Balancer"
}

output "bastion_security_group_id" {
  value       = aws_security_group.bastion_sg.id
  description = "The ID of the bastion host security group"
}

output "sns_cloudwatch_alarm_topic" {
  value       = length(aws_sns_topic.cloudwatch_alarm_topic) > 0 ? aws_sns_topic.cloudwatch_alarm_topic[0].arn : ""
  description = "The ARN of the cloudwatch SNS alarm topic"
}
