resource "aws_kinesis_stream" "input_data_stream" {
  name = "${local.env_prefix}-input-lambda"

  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }
}

resource "aws_kinesis_stream_consumer" "kinesis_stream_consumer" {
  name       = "${local.env_prefix}-kinesis-consumer"
  stream_arn = aws_kinesis_stream.input_data_stream.arn
}
