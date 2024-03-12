module "labels" {
  source      = "cloudposse/label/null"
  name        = var.name
  label_order = var.label_order
}

#region Archive files data

data "archive_file" "get_all_authors" {
  type        = "zip"
  source_file = "lambda/functions/get-all-authors/get-all-authors.js"
  output_path = "lambda/functions/get-all-authors/get-all-authors.zip"
}

data "archive_file" "save_course" {
  type        = "zip"
  source_file = "lambda/functions/save-course/save-course.js"
  output_path = "lambda/functions/save-course/save-course.zip"
}

#endregion

#region Lambdas

resource "aws_lambda_function" "get_all_authors" {
  filename      = data.archive_file.get_all_authors.output_path
  function_name = "${module.labels.id}-get-all-authors"
  role          = var.get_all_authors_arn
  handler       = "get-all-authors.handler"

  source_code_hash = data.archive_file.get_all_authors.output_base64sha256

  runtime = "nodejs16.x"
  environment {
    variables = {
      "TABLE_NAME" = "authors"
    }
  }
}

resource "aws_lambda_function" "save_course" {
  filename      = data.archive_file.save_course.output_path
  function_name = "${module.labels.id}-save-course"
  role          = var.save_course_arn
  handler       = "save-course.handler"

  source_code_hash = data.archive_file.save_course.output_base64sha256

  runtime = "nodejs16.x"
  environment {
    variables = {
      "TABLE_NAME" = "courses"
    }
  }
}

#endregion
