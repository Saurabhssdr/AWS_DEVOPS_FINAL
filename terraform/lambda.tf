resource "aws_lambda_function" "api_handler_lambda" {
  function_name = "api-handler"
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn      
  filename      = "${path.module}/api_handler.zip"
  timeout       = 30

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.csv_bucket.bucket
      SECRET_NAME = aws_secretsmanager_secret.table_secret.name
    }
  }
}

resource "aws_lambda_function" "s3_trigger_lambda" {
  function_name = "s3-trigger-processor"
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn     
  filename      = "${path.module}/s3_trigger.zip"
  source_code_hash = filebase64sha256("${path.module}/s3_trigger.zip")
  timeout       = 60

  environment {
    variables = {
      SECRET_NAME = aws_secretsmanager_secret.table_secret.name
      QUEUE_URL   = aws_sqs_queue.csv_cleanup_queue.id
    }
  }
}

resource "aws_lambda_function" "sqs_trigger_lambda" {
  function_name = "sqs-trigger-cleanup"
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn     
  filename      = "${path.module}/sqs_trigger.zip"
  timeout       = 30

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.csv_bucket.bucket
    }
  }
}
