module "labels" {
  source = "cloudposse/label/null"

  name  = var.name
  stage = var.stage
}

resource "aws_api_gateway_rest_api" "main" {
  name = "${module.labels.id}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.main.body))
  }

  depends_on = [
    aws_api_gateway_method.get_all_authors,
    aws_api_gateway_method.get_all_courses,
    aws_api_gateway_method.get_course,
    aws_api_gateway_method.post_course,
    aws_api_gateway_method.put_course,
    aws_api_gateway_method.delete_course,
    aws_api_gateway_integration.get_all_authors,
    aws_api_gateway_integration.get_all_courses,
    aws_api_gateway_integration.get_course,
    aws_api_gateway_integration.post_course,
    aws_api_gateway_integration.put_course,
    aws_api_gateway_integration.delete_course
  ]
}

resource "aws_api_gateway_stage" "dev" {
  stage_name    = "${module.labels.stage}-stage"
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
}

# region API resources

resource "aws_api_gateway_resource" "author" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "author"
}

resource "aws_api_gateway_resource" "author_all" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.author.id
  path_part   = "all"
}

resource "aws_api_gateway_resource" "author_all_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.author_all.id
  path_part   = "get"
}

resource "aws_api_gateway_resource" "course" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "course"
}

resource "aws_api_gateway_resource" "course_all" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.course.id
  path_part   = "all"
}

resource "aws_api_gateway_resource" "course_all_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.course_all.id
  path_part   = "get"
}

resource "aws_api_gateway_resource" "course_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.course.id
  path_part   = "get"
}

resource "aws_api_gateway_resource" "course_get_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.course_get.id
  path_part   = "{id}"
}

resource "aws_api_gateway_resource" "course_post" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.course.id
  path_part   = "post"
}

resource "aws_api_gateway_resource" "course_put" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.course.id
  path_part   = "put"
}

resource "aws_api_gateway_resource" "course_delete" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.course.id
  path_part   = "delete"
}

resource "aws_api_gateway_resource" "course_delete_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.course_delete.id
  path_part   = "{id}"
}

# endregion

# region Models

resource "aws_api_gateway_model" "post_course" {
  name         = "CourseInputModel"
  rest_api_id  = aws_api_gateway_rest_api.main.id
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/schema#",
  "title": "CourseInputModel",
  "type": "object",
  "properties": {
    "title": {
      "type": "string"
    },
    "authorId": {
      "type": "string"
    },
    "length": {
      "type": "string"
    },
    "category": {
      "type": "string"
    }
  },
  "required": [
    "title",
    "authorId",
    "length",
    "category"
  ]
}
EOF
}

resource "aws_api_gateway_model" "put_course" {
  name         = "CourseUpdateModel"
  rest_api_id  = aws_api_gateway_rest_api.main.id
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/schema#",
  "title": "CourseInputModel",
  "type": "object",
  "properties": {
    "id": {
      "type": "string"
    },
    "title": {
      "type": "string"
    },
    "watchHref": {
      "type": "string"
    },
    "authorId": {
      "type": "string"
    },
    "length": {
      "type": "string"
    },
    "category": {
      "type": "string"
    }
  },
  "required": [
    "id",
    "title",
    "watchHref",
    "authorId",
    "length",
    "category"
  ]
}
EOF
}

# endregion

# region Methods

resource "aws_api_gateway_method" "get_all_authors" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.author_all_get.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_all_courses" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.course_all_get.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_course" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.course_get_id.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_course" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.course_post.id
  http_method   = "POST"
  authorization = "NONE"

  request_models = {
    "application/json" = aws_api_gateway_model.post_course.name
  }
}

resource "aws_api_gateway_method" "put_course" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.course_put.id
  http_method   = "PUT"
  authorization = "NONE"

  request_models = {
    "application/json" = aws_api_gateway_model.put_course.name
  }
}

resource "aws_api_gateway_method" "delete_course" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.course_delete_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}

# endregion

# resource Integrations

resource "aws_api_gateway_integration" "get_all_authors" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.author_all_get.id
  http_method             = aws_api_gateway_method.get_all_authors.http_method
  integration_http_method = "POST"
  type                    = "AWS"

  uri = var.get_all_authors_invoke_arn
}

resource "aws_api_gateway_integration" "get_all_courses" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.course_all_get.id
  http_method             = aws_api_gateway_method.get_all_courses.http_method
  integration_http_method = "POST"
  type                    = "AWS"

  uri = var.get_all_courses_invoke_arn
}

resource "aws_api_gateway_integration" "get_course" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.course_get_id.id
  http_method             = aws_api_gateway_method.get_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"

  uri = var.get_course_invoke_arn

  request_templates = {
    "application/json" = "{\"id\": \"$input.params('id')\"}"
  }
}

resource "aws_api_gateway_integration" "post_course" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.course_post.id
  http_method             = aws_api_gateway_method.post_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"

  uri = var.save_course_invoke_arn

  request_templates = {
    "application/xml" = <<EOF
{
   "body": $input.json('$')
}
EOF
  }
}

resource "aws_api_gateway_integration" "put_course" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.course_put.id
  http_method             = aws_api_gateway_method.put_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"

  uri = var.update_course_invoke_arn

  request_templates = {
    "application/xml" = <<EOF
{
   "body": $input.json('$')
}
EOF
  }
}

resource "aws_api_gateway_integration" "delete_course" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.course_delete_id.id
  http_method             = aws_api_gateway_method.delete_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"

  uri = var.delete_course_invoke_arn

  request_templates = {
    "application/json" = "{\"id\": \"$input.params('id')\"}"
  }
}

# endregion

# region Lambda permissions

resource "aws_lambda_permission" "get_all_authors" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_all_authors_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}


resource "aws_lambda_permission" "get_all_courses" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_all_courses_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "get_course" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_course_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "post_course" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.save_course_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "put_course" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.update_course_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

resource "aws_lambda_permission" "delete_course" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.delete_course_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# endregion

# region Method responses

resource "aws_api_gateway_method_response" "get_all_authors" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.author_all_get.id
  http_method = aws_api_gateway_method.get_all_authors.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_method_response" "get_all_courses" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_all_get.id
  http_method = aws_api_gateway_method.get_all_courses.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_method_response" "get_course" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_get_id.id
  http_method = aws_api_gateway_method.get_course.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_method_response" "post_course" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_post.id
  http_method = aws_api_gateway_method.post_course.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_method_response" "put_course" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_put.id
  http_method = aws_api_gateway_method.put_course.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_method_response" "delete_course" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_delete_id.id
  http_method = aws_api_gateway_method.delete_course.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

# endregion

# region Integration responses

resource "aws_api_gateway_integration_response" "get_all_authors" {
  depends_on = [
    aws_api_gateway_integration.get_all_authors
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.author_all_get.id
  http_method = aws_api_gateway_method.get_all_authors.http_method
  status_code = aws_api_gateway_method_response.get_all_authors.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
  }
}

resource "aws_api_gateway_integration_response" "get_all_courses" {
  depends_on = [
    aws_api_gateway_integration.get_all_courses
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_all_get.id
  http_method = aws_api_gateway_method.get_all_courses.http_method
  status_code = aws_api_gateway_method_response.get_all_courses.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, OPTIONS'"
  }
}

resource "aws_api_gateway_integration_response" "get_course" {
  depends_on = [
    aws_api_gateway_integration.get_course
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_get_id.id
  http_method = aws_api_gateway_method.get_course.http_method
  status_code = aws_api_gateway_method_response.get_course.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, OPTIONS'"
  }
}

resource "aws_api_gateway_integration_response" "post_course" {
  depends_on = [
    aws_api_gateway_integration.post_course
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_post.id
  http_method = aws_api_gateway_method.post_course.http_method
  status_code = aws_api_gateway_method_response.post_course.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, OPTIONS, POST'"
  }
}

resource "aws_api_gateway_integration_response" "put_course" {
  depends_on = [
    aws_api_gateway_integration.put_course
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_put.id
  http_method = aws_api_gateway_method.put_course.http_method
  status_code = aws_api_gateway_method_response.put_course.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, OPTIONS, PUT'"
  }
}

resource "aws_api_gateway_integration_response" "delete_course" {
  depends_on = [
    aws_api_gateway_integration.delete_course
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_delete_id.id
  http_method = aws_api_gateway_method.delete_course.http_method
  status_code = aws_api_gateway_method_response.delete_course.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, OPTIONS, DELETE'"
  }
}

# endregion

# region CORS

resource "aws_api_gateway_method" "options_author_all_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.author_all_get.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_course_all_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.course_all_get.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_course_get_id" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.course_get_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_course_post" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.course_post.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_course_put" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.course_put.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_course_delete_id" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.course_delete_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_author_all_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.author_all_get.id
  http_method = aws_api_gateway_method.options_author_all_get.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration" "options_course_all_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_all_get.id
  http_method = aws_api_gateway_method.options_course_all_get.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration" "options_course_get_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_get_id.id
  http_method = aws_api_gateway_method.options_course_get_id.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration" "options_course_post" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_post.id
  http_method = aws_api_gateway_method.options_course_post.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration" "options_course_put" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_put.id
  http_method = aws_api_gateway_method.options_course_put.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration" "options_course_delete_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_delete_id.id
  http_method = aws_api_gateway_method.options_course_delete_id.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_author_all_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.author_all_get.id
  http_method = aws_api_gateway_method.options_author_all_get.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "options_course_all_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_all_get.id
  http_method = aws_api_gateway_method.options_course_all_get.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "options_course_get_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_get_id.id
  http_method = aws_api_gateway_method.options_course_get_id.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "options_course_post" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_post.id
  http_method = aws_api_gateway_method.options_course_post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "options_course_put" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_put.id
  http_method = aws_api_gateway_method.options_course_put.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_method_response" "options_course_delete_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_delete_id.id
  http_method = aws_api_gateway_method.options_course_delete_id.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "options_author_all_get" {
  depends_on = [
    aws_api_gateway_integration.options_author_all_get
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.author_all_get.id
  http_method = aws_api_gateway_method.options_author_all_get.http_method
  status_code = aws_api_gateway_method_response.options_author_all_get.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "options_course_all_get" {
  depends_on = [
    aws_api_gateway_integration.options_course_all_get
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_all_get.id
  http_method = aws_api_gateway_method.options_course_all_get.http_method
  status_code = aws_api_gateway_method_response.options_course_all_get.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "options_course_get_id" {
  depends_on = [
    aws_api_gateway_integration.options_course_get_id
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_get_id.id
  http_method = aws_api_gateway_method.options_course_get_id.http_method
  status_code = aws_api_gateway_method_response.options_course_get_id.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "options_course_post" {
  depends_on = [
    aws_api_gateway_integration.options_course_post
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_post.id
  http_method = aws_api_gateway_method.options_course_post.http_method
  status_code = aws_api_gateway_method_response.options_course_post.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "options_course_put" {
  depends_on = [
    aws_api_gateway_integration.options_course_put
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_put.id
  http_method = aws_api_gateway_method.options_course_put.http_method
  status_code = aws_api_gateway_method_response.options_course_put.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_integration_response" "options_course_delete_id" {
  depends_on = [
    aws_api_gateway_integration.options_course_delete_id
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.course_delete_id.id
  http_method = aws_api_gateway_method.options_course_delete_id.http_method
  status_code = aws_api_gateway_method_response.options_course_delete_id.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,DELETE'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# endregion
