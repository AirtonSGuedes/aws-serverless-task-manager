# =========================
# API Gateway HTTP API
# =========================
resource "aws_apigatewayv2_api" "http_api" {
  name          = "tasks-http-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "DELETE", "OPTIONS"]
    allow_headers = ["*"]
  }
}

# =========================
# Integration
# =========================
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.tasks_lambda.invoke_arn
  payload_format_version = "2.0"
}

# =========================
# Routes
# =========================
resource "aws_apigatewayv2_route" "post_tasks" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /tasks"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "get_tasks" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /tasks"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "delete_task" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "DELETE /tasks/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# =========================
# Stage
# =========================
resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}
