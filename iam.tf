
# resource "aws_lambda_permission" "logging" {
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.logging.function_name
#   principal     = "logs.eu-west-1.amazonaws.com"
#   source_arn    = "${aws_cloudwatch_log_group.default.arn}:*"
# }

# resource "aws_cloudwatch_log_group" "default" {
#   name = "/default"
# }

# resource "aws_cloudwatch_log_subscription_filter" "logging" {
#   depends_on      = [aws_lambda_permission.logging]
#   destination_arn = aws_lambda_function.logging.arn
#   filter_pattern  = ""
#   log_group_name  = aws_cloudwatch_log_group.default.name
#   name            = "logging_default"
# }

# resource "aws_lambda_function" "logging" {
#   filename      = "lamba_logging.zip"
#   function_name = "lambda_called_from_cloudwatch_logs"
#   handler       = "exports.handler"
#   role          = aws_iam_role.default.arn
#   runtime       = "python3.8"
# }

# resource "aws_iam_role" "default" {
#   name = "iam_for_lambda_called_from_cloudwatch_logs"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }
# data "aws_iam_policy_document" "lambda_policy_doc" {
#   statement {
#     sid = "AllowInvokingLambdas"
#     effect = "Allow"

#     resources = [
#       "arn:aws:lambda:*:*:function:*"
#     ]

#     actions = [
#       "lambda:InvokeFunction"
#     ]
#   }

#   statement {
#     sid = "AllowCreatingLogGroups"
#     effect = "Allow"

#     resources = [
#       "arn:aws:logs:*:*:*"
#     ]

#     actions = [
#       "logs:CreateLogGroup"
#     ]
#   }

#   statement {
#     sid = "AllowWritingLogs"
#     effect = "Allow"

#     resources = [
#       "arn:aws:logs:*:*:log-group:/aws/lambda/*:*"
#     ]

#     actions = [
#       "logs:CreateLogStream",
#       "logs:PutLogEvents",
#     ]
#   }
# }

resource "aws_iam_policy" "sele_lambda" {
  name = "selene_would_like_to_deploy_lambda"
  path = "/"
  description = "Policy for lambda"

  policy = <<EOF

  {
   Version": "2012-10-17",
   "Statement": [
   {
        "Sid": ""
        "Action": "logs:*",
        "Effect": "Allow",
        "Resource": "*"
        
    }
  ]
}
}
EOF
}

#IAM Role for Lambda

resource "aws_iam_role" "sele_lambda_role" {
    name = "sele_lambda_role"

    assume_role_policy = <<EOF
    {
     "Version": "2012-10-17",
     "Statement": [
       {
           "Action": "sts:AssumeRole",
           "Principal": {
               "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow"
       }  
     ]   
    }
    EOF
  }

  #Attach role and policy
  resource "aws_iam_role_policy_attachment" "sele_lambda_attach" {
    role = aws_iam_role.sele_lambda_role.name
    policy_arn = aws_iam_policy.sele_lambda.arn
  }






