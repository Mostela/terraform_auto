provider "aws" {
  region = "us-east-1"
}

resource "aws_api_gateway_rest_api" "gateway" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = var.name_api
      version = "1.0"
    }
    paths = {
      "/amazon" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  name = var.name_api

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.gateway.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.gateway.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_api_key" "MyApiKey" {
  name = var.api_key_name
}

resource "aws_api_gateway_stage" "version_api" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.gateway.id
  stage_name    = var.version_api
}