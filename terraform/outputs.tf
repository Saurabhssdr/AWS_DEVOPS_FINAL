output "api_gateway_url" {
  value = "${aws_api_gateway_rest_api.csv_api.execution_arn}/details"
}
