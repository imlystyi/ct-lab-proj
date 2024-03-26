# region DynamoDB modules

module "dynamodb_authors" {
  source = "./dynamodb"

  name  = "dynamodb-authors"
  stage = "dev"
}

module "dynamodb_courses" {
  source = "./dynamodb"

  name  = "dynamodb-courses"
  stage = "dev"
}

# endregion

module "iam" {
  source = "./iam"

  name  = "iam"
  stage = "dev"

  dynamodb_authors_arn = module.dynamodb_authors.dynamodb_arn
  dynamodb_courses_arn = module.dynamodb_courses.dynamodb_arn
}

module "lambda" {
  source = "./lambda"

  name  = "lambda"
  stage = "dev"

  get_all_authors_arn = module.iam.get_all_authors_lambda_role_arn
  get_all_courses_arn = module.iam.get_all_courses_lambda_role_arn
  get_course_arn      = module.iam.get_course_lambda_role_arn
  save_course_arn     = module.iam.put_course_lambda_role_arn
  update_course_arn   = module.iam.put_course_lambda_role_arn
  delete_course_arn   = module.iam.delete_course_lambda_role_arn
}

module "api" {
  source = "./api"

  name  = "api"
  stage = "dev"

  get_all_authors_arn        = module.lambda.get_all_authors_arn
  get_all_authors_invoke_arn = module.lambda.get_all_authors_invoke_arn
}
