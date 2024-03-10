module "dynamo_db_authors" {
  source  = "./dynamodb"
  name    = "authors"
}

module "dynamo_db_courses" {
  source  = "./dynamodb"
  name    = "courses"
}