output "api_gw_endpoint" {
  description = "Endpoint for API Gateway"

  value = aws_apigatewayv2_stage.api_gw_stage.invoke_url
}
