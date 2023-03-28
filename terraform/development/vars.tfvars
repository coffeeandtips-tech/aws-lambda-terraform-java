bucket = "your.bucket.name.must.be.unique"
lambda_function = "coffee_tips_aws_lambda"
lambda_filename = "aws-lambda-terraform-java-1.0.jar"
file_location = "../target/aws-lambda-terraform-java-1.0.jar"
lambda_handler = "coffee.tips.lambda.Handler"
runtime = "java11"
cron = "rate(2 minutes)"
timeout = 2