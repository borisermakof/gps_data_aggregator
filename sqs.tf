#resource "aws_sqs_queue" "receive_queue" {
#  name                      = local.env_prefix
#  delay_seconds             = 15
#  message_retention_seconds = 3600
#  receive_wait_time_seconds = 10
#}
