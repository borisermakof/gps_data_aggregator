resource "aws_apigatewayv2_api" "api_gw" {
  name          = "${local.env_prefix}_api_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "api_gw_stage" {
  api_id = aws_apigatewayv2_api.api_gw.id

  name        = "${local.env_prefix}_api_gw_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "lambda_api_integration" {
  api_id = aws_apigatewayv2_api.api_gw.id

  integration_uri    = aws_lambda_function.lambda_api.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_integration" "lambda_api_integration_get" {
  api_id = aws_apigatewayv2_api.api_gw.id

  integration_uri    = aws_lambda_function.lambda_api_get.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "lambda_api_route" {
  api_id = aws_apigatewayv2_api.api_gw.id

  route_key = "POST /add_point"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_api_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_api_route_get" {
  api_id = aws_apigatewayv2_api.api_gw.id

  route_key = "GET /get_regions_data"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_api_integration_get.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.api_gw.name}"

  retention_in_days = 14
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_api.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gw.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_get_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_api_get.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gw.execution_arn}/*/*"
}
