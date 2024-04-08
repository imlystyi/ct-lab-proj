output "get_all_authors_role_arn" {
  value = aws_iam_role.get_all_authors.arn
}

output "get_all_courses_role_arn" {
  value = aws_iam_role.get_all_courses.arn
}

output "get_course_role_arn" {
  value = aws_iam_role.get_course.arn
}

output "put_course_role_arn" {
  value = aws_iam_role.put_course.arn
}

output "delete_course_role_arn" {
  value = aws_iam_role.delete_course.arn
}
