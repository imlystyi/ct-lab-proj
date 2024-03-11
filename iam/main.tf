module "labels" {
  source = "cloudposse/label/null"
  name   = var.name
}

# region function: get_all_authors

resource "aws_iam_role" "get_all_authors_lambda_role" {
  name = "${module.labels.id}-get-all-authors-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_policy" "get_all_authors_lambda_policy" {
  name = "${module.labels.id}-get-all-authors-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Scan",
        ],
      Resource = var.dynamodb_authors_arn,
      Effect   = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "get_all_authors_lambda_policy_attachment" {
  role       = aws_iam_role.get_all_authors_lambda_role.name
  policy_arn = aws_iam_policy.get_all_authors_lambda_policy.arn
}

#endregion
