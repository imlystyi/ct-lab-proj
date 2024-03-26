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
}

resource "aws_api_gateway_stage" "dev_stage" {
  stage_name    = "${module.labels.stage}-stage"
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
}

resource "aws_api_gateway_resource" "authors_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "authors"
}

# region Methods

resource "aws_api_gateway_method" "get_all_authors_method" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.authors_api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# endregion

# resource Integrations

resource "aws_api_gateway_integration" "get_all_authors_integration" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.authors_api_resource.id
  http_method             = aws_api_gateway_method.get_all_authors_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"

  uri = var.get_all_authors_invoke_arn
}

# endregion

# region Lambda permissions

resource "aws_lambda_permission" "get_all_authors_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_all_authors_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# endregion

# region Method responses

resource "aws_api_gateway_method_response" "get_all_authors_method_response" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.authors_api_resource.id
  http_method = aws_api_gateway_method.get_all_authors_method.http_method
  status_code = "200"
}

# endregion

# region Integration responses

resource "aws_api_gateway_integration_response" "get_all_authors_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.authors_api_resource.id
  http_method = aws_api_gateway_method.get_all_authors_method.http_method
  status_code = aws_api_gateway_method_response.get_all_authors_method_response.status_code
}

# endregion
