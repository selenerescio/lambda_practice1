data "archive_file" "init" {
    type = "zip"
    source_file = "lambda.py"
    output_path = " lambda.zip"
}

resource "aws_lambda_function" "sele_lambda" {
  filename = data.archive_file.init.output_path
  function_name = "sele_lambda_demo"
  role = aws_iam_role.sele_lambda_role.Policy_arn
  handler = "sele_lambda.lambda_handler"

  source_code_hash = filebase64sha256(data.archive_file.init.output.path)

  runtime = "python3.8"
}