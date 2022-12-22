
data "archive_file" "lambda_api_zip" {
  type = "zip"

  source_dir  = "${local.lambda_source_path}/api"
  output_path = "${local.lambda_output_zip}/api.zip"
}

data "archive_file" "lambda_api_get_zip" {
  type = "zip"

  source_dir  = "${local.lambda_source_path}/api_get"
  output_path = "${local.lambda_output_zip}/api_get.zip"
}

data "archive_file" "lambda_processor_zip" {
  type = "zip"

  source_dir  = "${local.lambda_source_path}/processor"
  output_path = "${local.lambda_output_zip}/processor.zip"
}

resource "aws_lambda_function" "lambda_api" {
  filename      = data.archive_file.lambda_api_zip.output_path
  function_name = "${local.env_prefix}-api"
  role          = aws_iam_role.iam_lambda_role_api.arn
  handler       = "api.lambda_handler"
  description   = "main hive api entry point"

  reserved_concurrent_executions = 2

  source_code_hash = data.archive_file.lambda_api_zip.output_base64sha256

  runtime = "python3.9"

  vpc_config {
    security_group_ids = [aws_security_group.main_vpc_sg[0].id]
    subnet_ids         = module.vpc.private_subnets
  }

  environment {
    variables = {
      KINESIS_STREAM_NAME = aws_kinesis_stream.input_data_stream.name
    }
  }

  tags = {
    Name = "${local.env_prefix}-lambda-api",
  }
}

resource "aws_lambda_function" "lambda_api_get" {
  filename      = data.archive_file.lambda_api_get_zip.output_path
  function_name = "${local.env_prefix}-api-get"
  role          = aws_iam_role.iam_lambda_role_api_get.arn
  handler       = "api_get.lambda_handler"
  description   = "main hive api get entry point"

  reserved_concurrent_executions = 2

  source_code_hash = data.archive_file.lambda_api_get_zip.output_base64sha256

  runtime = "python3.9"

  vpc_config {
    security_group_ids = [aws_security_group.main_vpc_sg[0].id]
    subnet_ids         = module.vpc.private_subnets
  }

  environment {
    variables = {
      DYNAMO_TABLE_NAME = local.dymano_table_name
    }
  }

  tags = {
    Name = "${local.env_prefix}-lambda-api",
  }
}

resource "aws_lambda_function" "lambda_processor" {
  filename      = data.archive_file.lambda_processor_zip.output_path
  function_name = "${local.env_prefix}-processor"
  role          = aws_iam_role.iam_lambda_role_processor.arn
  handler       = "processor.lambda_handler"
  description   = "main hive dta processor"

  reserved_concurrent_executions = 2

  source_code_hash = data.archive_file.lambda_processor_zip.output_base64sha256

  runtime = "python3.9"

  vpc_config {
    security_group_ids = [aws_security_group.main_vpc_sg[0].id]
    subnet_ids         = module.vpc.private_subnets
  }

  environment {
    variables = {
      DYNAMO_TABLE_NAME = local.dymano_table_name
    }
  }

  tags = {
    Name = "${local.env_prefix}-lambda-processor",
  }
}

resource "aws_lambda_event_source_mapping" "processor_from_kinesis" {
  event_source_arn  = aws_kinesis_stream.input_data_stream.arn
  function_name     = aws_lambda_function.lambda_processor.arn
  starting_position = "LATEST"

  batch_size                         = 10000
  maximum_batching_window_in_seconds = 60
  tumbling_window_in_seconds         = 60

  # no need to spam right now, during test task
  maximum_retry_attempts = 1
}

#resource "aws_lambda_function_event_invoke_config" "lambda_send_sqs" {
#  function_name = aws_lambda_function.lambda_api.function_name
#
#  destination_config {
#    on_success {
#      destination = aws_sqs_queue.receive_queue.arn
#    }
#  }
#}
