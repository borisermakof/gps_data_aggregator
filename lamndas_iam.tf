
resource "aws_iam_role" "iam_lambda_role_api" {
  name = "${local.env_prefix}-iam_lambda_role_api"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "iam_lambda_role_api_get" {
  name = "${local.env_prefix}-iam_lambda_role_api_get"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "iam_lambda_role_processor" {
  name = "${local.env_prefix}-iam_lambda_role_processor"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_api" {
  name        = "${local.env_prefix}-lambda_api"
  path        = "/"
  description = "IAM policy for api lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kinesis:PutRecord"
      ],
      "Resource": "${aws_kinesis_stream.input_data_stream.arn}",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_api_get" {
  name        = "${local.env_prefix}-lambda_api_get"
  path        = "/"
  description = "IAM policy for api get lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:Query"
      ],
      "Resource": "${aws_dynamodb_table.aggregated_data.arn}",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_processor" {
  name        = "${local.env_prefix}-lambda_processor"
  path        = "/"
  description = "IAM policy for processor lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:DescribeStreamSummary",
        "kinesis:GetRecords",
        "kinesis:GetShardIterator",
        "kinesis:ListShards",
        "kinesis:ListStreams",
        "kinesis:SubscribeToShard"
      ],
      "Resource": "${aws_kinesis_stream.input_data_stream.arn}",
      "Effect": "Allow"
    },
    {
      "Action": [
        "dynamodb:BatchWriteItem"
      ],
      "Resource": "${aws_dynamodb_table.aggregated_data.arn}",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_logs" {
  name        = "${local.env_prefix}-lambda_logs"
  path        = "/"
  description = "IAM policy for creating/sending logs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "lambda_api_execution_attachment" {
  role       = aws_iam_role.iam_lambda_role_api.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_api_get_execution_attachment" {
  role       = aws_iam_role.iam_lambda_role_api_get.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_processor_execution_attachment" {
  role       = aws_iam_role.iam_lambda_role_processor.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_api_logs" {
  role       = aws_iam_role.iam_lambda_role_api.name
  policy_arn = aws_iam_policy.lambda_api.arn
}

resource "aws_iam_role_policy_attachment" "lambda_api_get_logs" {
  role       = aws_iam_role.iam_lambda_role_api_get.name
  policy_arn = aws_iam_policy.lambda_api_get.arn
}


resource "aws_iam_role_policy_attachment" "lambda_processor_logs" {
  role       = aws_iam_role.iam_lambda_role_processor.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}

resource "aws_iam_role_policy_attachment" "lambda_api" {
  role       = aws_iam_role.iam_lambda_role_api.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}

resource "aws_iam_role_policy_attachment" "lambda_processor" {
  role       = aws_iam_role.iam_lambda_role_processor.name
  policy_arn = aws_iam_policy.lambda_processor.arn
}
