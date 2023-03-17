module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name               = var.ambiante
  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }
}
resource "aws_ecs_task_definition" "Django-API" {
  depends_on = [aws_docdb_cluster_instance.servless_app]
  family                   = "Django-API"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.cargo.arn
  container_definitions = jsonencode(
    [
      {
        "name"      = "producao"
        "image"     = "aquijuz/curso-serverless:v1"
        "cpu"       = 256
        "memory"    = 512
        "essential" = true
        "environment" = [
          {
            "name"  = "STRING_CONEXAO_DB"
            "value" = "mongodb://alura:admin123@${aws_docdb_cluster_instance.servless_app.endpoint}:${aws_docdb_cluster_instance.servless_app.port}/?tls=true&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
          }
        ]
        "portMappings" = [
          {
            "containerPort" = 80
            "hostPort"      = 80
          }
        ]
      }
    ]
  )
}


resource "aws_ecs_service" "Django-API" {
  name            = "Django-API"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.Django-API.arn
  force_new_deployment = true
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.alvo.arn
    container_name   = "producao"
    container_port   = 80
  }

  network_configuration {
      subnets = module.vpc.private_subnets
      security_groups = [aws_security_group.privado.id]
  }

  capacity_provider_strategy {
      capacity_provider = "FARGATE"
      weight = 1 #100/100
  }
}
