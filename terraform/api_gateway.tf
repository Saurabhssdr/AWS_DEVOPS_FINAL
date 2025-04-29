resource "aws_api_gateway_rest_api" "csv_api" {
  name = "csv-upload-api"
}

resource "aws_api_gateway_resource" "details_resource" {
  rest_api_id = aws_api_gateway_rest_api.csv_api.id
  parent_id   = aws_api_gateway_rest_api.csv_api.root_resource_id
  path_part   = "details"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.csv_api.id
  resource_id   = aws_api_gateway_resource.details_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.csv_api.id
  resource_id   = aws_api_gateway_resource.details_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.csv_api.id
  resource_id             = aws_api_gateway_resource.details_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_handler_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.csv_api.id
  resource_id             = aws_api_gateway_resource.details_resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_handler_lambda.invoke_arn
}

resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_handler_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.csv_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "csv_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.csv_api.id
  stage_name  = "dev"  

  depends_on = [
    aws_api_gateway_integration.post_integration,
    aws_api_gateway_integration.get_integration
  ]
}

