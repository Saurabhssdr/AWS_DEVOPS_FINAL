# Create the SQS queue
resource "aws_sqs_queue" "csv_cleanup_queue" {
  name                       = "csv-upload-cleanup-queue"
  delay_seconds              = 120  # 2-minute delay
  visibility_timeout_seconds = 300
}

# Connect the SQS queue to the already defined Lambda function
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.csv_cleanup_queue.arn
  function_name    = aws_lambda_function.sqs_trigger_lambda.function_name
  batch_size       = 1
  enabled          = true
}
