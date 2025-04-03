resource "aws_lambda_function" "log_s3_upload" {
  function_name = "log-s3-upload"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "log_handler.lambda_handler"
  runtime       = "python3.11"
  filename      = "${path.module}/../lambda/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/lambda.zip")
  timeout       = 10
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_s3_upload.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.upload_bucket}"
}

resource "aws_s3_bucket_notification" "upload_trigger" {
  bucket = var.upload_bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.log_s3_upload.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}