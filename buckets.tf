
resource "aws_s3_bucket" "talent-academy-471202980415-tfstates" {
  bucket = var.bucket_for_videos
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.talent-academy-471202980415-tfstates.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.sele_lambda.arn
    events = ["s3:ObjectCreated:*"]
    filter_suffix = ".jpg"
  }
}