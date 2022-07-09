provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster-name
}


resource "aws_ecs_task_definition" "task-definition" {
  family = "${var.task-name}-svc"
  container_definitions = jsonencode([
    {
      name      = var.task-name
      image     = var.task-image
      cpu       = 1
      memory    = 128
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = "${var.task-name}-svc"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task-definition.arn
  desired_count   = 1
}

output "service_count" {
  value = aws_ecs_service.service.count
}