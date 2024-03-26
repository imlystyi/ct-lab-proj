output "get_all_authors_arn" {
  value = aws_lambda_function.get_all_authors.arn
}

output "get_all_authors_invoke_arn" {
  value = aws_lambda_function.get_all_authors.invoke_arn
}
