# region DynamoDB modules

module "dynamodb_author" {
  source = "./dynamodb"

  name  = "author"
}

module "dynamodb_course" {
  source = "./dynamodb"

  name  = "course"
}

# endregion

module "iam" {
  source = "./iam"

  name  = "iam"
  stage = "dev"

  dynamodb_author_arn = module.dynamodb_author.dynamodb_arn
  dynamodb_course_arn = module.dynamodb_course.dynamodb_arn
}

module "lambda" {
  source = "./lambda"

  name  = "lambda"
  stage = "dev"

  get_all_authors_arn = module.iam.get_all_authors_role_arn
  get_all_courses_arn = module.iam.get_all_courses_role_arn
  get_course_arn      = module.iam.get_course_role_arn
  save_course_arn     = module.iam.put_course_role_arn
  update_course_arn   = module.iam.put_course_role_arn
  delete_course_arn   = module.iam.delete_course_role_arn
}

module "api" {
  source = "./api"

  name  = "api"
  stage = "dev"

  get_all_authors_arn = module.lambda.get_all_authors_arn
  get_all_courses_arn = module.lambda.get_all_courses_arn
  get_course_arn      = module.lambda.get_course_arn
  save_course_arn     = module.lambda.save_course_arn
  update_course_arn   = module.lambda.update_course_arn
  delete_course_arn   = module.lambda.delete_course_arn

  get_all_authors_invoke_arn = module.lambda.get_all_authors_invoke_arn
  get_all_courses_invoke_arn = module.lambda.get_all_courses_invoke_arn
  get_course_invoke_arn      = module.lambda.get_course_invoke_arn
  save_course_invoke_arn     = module.lambda.save_course_invoke_arn
  update_course_invoke_arn   = module.lambda.update_course_invoke_arn
  delete_course_invoke_arn   = module.lambda.delete_course_invoke_arn
}
