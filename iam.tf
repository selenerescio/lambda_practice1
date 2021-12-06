
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

# resource "aws_iam_policy" "sele_lambda" {
#   name = "selene_would_like_to_deploy_lambda"
#   path = "/"
#   description = "Policy for lambda"

#   policy = <<EOF

#   {
#    Version": "2012-10-17",
#    "Statement": [
#    {
#         "Sid": ""
#         "Action": "logs:*",
#         "Effect": "Allow",
#         "Resource": "*"
        
#     }
#   ]
# }
# }
# EOF
# }

#IAM Role for Lambda

resource "aws_iam_role" "lambda_role" {
    name = "var.lambda_role_name"

    assume_role_policy = jsonencode({
    
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
    })

    tags = {
    Name = var.lambda_role_name
  }
}

  
# POLICY TO ALLOW MY LAMBDA TO ACCESS CLOUDWATCH LOGS
resource "aws_iam_policy" "lambda_cloudwatch_access" {
  name        = "lambda_CW_access"
  path        = "/"
  description = "My Policy to allow my lambda function to put logs into cloudwatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ELEMENT 1
      {
        "Sid" : "cwlogaccess"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*" # ALL CLOUDWATCH LogGroup RESOURCES
      },
      # ELEMENT 2
      {
        "Sid" : "s3List",
        "Action" : [
          "s3:List*"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      # ELEMENT 3
      {
        "Sid" : "s3access",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::${var.pet_bucket_name}", # ALLOW ON THIS BUCKET ONLY
          "arn:aws:s3:::${var.pet_bucket_name}/*"
        ]
      } 
    ]
  })
}

# ATTACH POLICY TO THE ROLE
resource "aws_iam_role_policy_attachment" "lambda_role_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_cloudwatch_access.arn
}

# ARN arn:aws:s3:::talent-academy-pascal-petbucket
#    -- name of the resource in AWS with a specific structure
# ID -- generated identifier e.g. i-123ewrewfs, sg-sdfs3434534





