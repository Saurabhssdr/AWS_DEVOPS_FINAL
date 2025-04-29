resource "aws_s3_bucket" "csv_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_lambda_permission" "allow_s3_trigger" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_trigger_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.csv_bucket.arn   # Corrected: using csv_bucket
}

resource "aws_s3_bucket_notification" "s3_trigger_notification" {
  bucket = aws_s3_bucket.csv_bucket.id   # Corrected: using csv_bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_trigger_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"  # Optional: if files are under uploads/ folder
  }

  depends_on = [aws_lambda_permission.allow_s3_trigger]
}
