module "dynamodb_authors" {
  source  = "./dynamodb"
  name    = "authors"
}

module "dynamodb_courses" {
  source  = "./dynamodb"
  name    = "courses"
}

module "iam" {
  source = "./iam"
  name   = "iam"

  dynamodb_authors_arn = module.dynamodb_authors.dynamodb_arn
  dynamodb_courses_arn = module.dynamodb_courses.dynamodb_arn
}

module "lambda" {
  source = "./lambda"
  name   = "lambda"

  get_all_authors_arn = module.iam.get_all_authors_role_arn
  save_course_arn     = module.iam.put_course_lambda_role_arn
  update_course_arn   = module.iam.put_course_lambda_role_arn
}
