resource "aws_sns_topic" "cloudwatch_alarm_topic" {
  count = var.enable_cloudwatch_alarm ? 1 : 0
  name  = "${var.environment}-cloudwatch-alarm-topic"
}

resource "aws_cloudwatch_metric_alarm" "nlb_unhealthy_host_count_alarm" {
  count               = var.enable_cloudwatch_alarm ? 1 : 0
  alarm_name          = "${var.environment}-UnhealthyHostCount-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    TargetGroup  = aws_lb_target_group.nlb_tg.arn_suffix
    LoadBalancer = aws_lb.nlb.arn_suffix
  }

  alarm_description = "Alarm when the bastion host target becomes unhealthy on port 22"
  alarm_actions     = [aws_sns_topic.cloudwatch_alarm_topic[0].arn]
}
