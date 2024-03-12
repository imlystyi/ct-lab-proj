output "get_all_authors_lambda_role_arn" {
  value = aws_iam_role.get_all_authors_lambda_role.arn
}

output "get_all_courses_lambda_role_arn" {
  value = aws_iam_role.get_all_courses_lambda_role.arn
}

output "get_course_lambda_role_arn" {
  value = aws_iam_role.get_course_lambda_role.arn
}

output "put_course_lambda_role_arn" {
  value = aws_iam_role.put_course_lambda_role.arn
}
