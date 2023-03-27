data "aws_iam_policy_document" "coffee_tips_aws_lambda_iam_policy_document" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "aws_iam_policy_coffee_tips_aws_lambda_iam_policy_document" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.coffee_tips_aws_lambda_iam_policy_document.json
}

resource "aws_iam_role_policy" "aws_lambda_iam_policy" {
  policy = data.aws_iam_policy_document.aws_iam_policy_coffee_tips_aws_lambda_iam_policy_document.json
  role = aws_iam_role.iam_for_lambda.id
}

resource "aws_s3_object" "s3_object_upload" {
  depends_on = [aws_s3_bucket.bucket]
  bucket = var.bucket
  key    = var.lambda_filename
  source = var.file_location
  etag = filemd5(var.file_location)
}

resource "aws_lambda_function" "coffee_tips_aws_lambda" {
  function_name = var.lambda_function
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.lambda_handler
  source_code_hash = aws_s3_object.s3_object_upload.key
  s3_bucket     = var.bucket
  s3_key        = var.lambda_filename
  runtime       = var.runtime
  timeout       = var.timeout
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name = "event_rule"
  schedule_expression = var.cron
}

resource "aws_cloudwatch_event_target" "event_target" {
  arn  = aws_lambda_function.coffee_tips_aws_lambda.arn
  rule = aws_cloudwatch_event_rule.event_rule.name
  target_id = aws_lambda_function.coffee_tips_aws_lambda.function_name
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.coffee_tips_aws_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.event_rule.arn
}
