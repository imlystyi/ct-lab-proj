module "labels" {
  source = "cloudposse/label/null"

  name  = var.name
  stage = var.stage
}

#region Roles

resource "aws_iam_role" "get_all_authors" {
  name = "${module.labels.id}-get-all-authors-role"

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

resource "aws_iam_role" "get_all_courses" {
  name = "${module.labels.id}-get-all-courses-role"

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

resource "aws_iam_role" "get_course" {
  name = "${module.labels.id}-get-course-role"

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

resource "aws_iam_role" "put_course" {
  name = "${module.labels.id}-put-course-role"

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

resource "aws_iam_role" "delete_course" {
  name = "${module.labels.id}-delete-course-role"

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

#endregion

# region Policies

resource "aws_iam_policy" "get_all_authors" {
  name = "${module.labels.id}-get-all-authors-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "dynamodb:Scan",
        ],
      Resource = var.dynamodb_author_arn,
      Effect   = "Allow"
    },
    {
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "arn:aws:logs:*:*:*",
      Effect   = "Allow"
    }]
  })
}

resource "aws_iam_policy" "get_all_courses" {
  name = "${module.labels.id}-get-all-courses-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "dynamodb:Scan"
        ],
      Resource = var.dynamodb_course_arn,
      Effect   = "Allow"
    },
    {
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "arn:aws:logs:*:*:*",
      Effect   = "Allow"
    }]
  })
}

resource "aws_iam_policy" "get_course" {
  name = "${module.labels.id}-get-course-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "dynamodb:GetItem"
        ],
      Resource = var.dynamodb_course_arn,
      Effect   = "Allow"
    },
    {
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "arn:aws:logs:*:*:*",
      Effect   = "Allow"
    }]
  })
}

resource "aws_iam_policy" "put_course" {
  name = "${module.labels.id}-put-course-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "dynamodb:PutItem"
        ],
      Resource = var.dynamodb_course_arn,
      Effect   = "Allow"
    },
    {
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "arn:aws:logs:*:*:*",
      Effect   = "Allow"
    }]
  })
}

resource "aws_iam_policy" "delete_course" {
  name = "${module.labels.id}-delete-course-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "dynamodb:DeleteItem"
        ],
      Resource = var.dynamodb_course_arn,
      Effect   = "Allow"
    },
    {
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "arn:aws:logs:*:*:*",
      Effect   = "Allow"
    }]
  })
}

#endregion

# region Policy attachments

resource "aws_iam_role_policy_attachment" "get_all_authors" {
  role       = aws_iam_role.get_all_authors.name
  policy_arn = aws_iam_policy.get_all_authors.arn
}

resource "aws_iam_role_policy_attachment" "get_all_courses" {
  role       = aws_iam_role.get_all_courses.name
  policy_arn = aws_iam_policy.get_all_courses.arn
}

resource "aws_iam_role_policy_attachment" "get_course" {
  role       = aws_iam_role.get_course.name
  policy_arn = aws_iam_policy.get_course.arn
}

resource "aws_iam_role_policy_attachment" "put_course" {
  role       = aws_iam_role.put_course.name
  policy_arn = aws_iam_policy.put_course.arn
}

resource "aws_iam_role_policy_attachment" "delete_course" {
  role       = aws_iam_role.delete_course.name
  policy_arn = aws_iam_policy.delete_course.arn
}

# endregion
