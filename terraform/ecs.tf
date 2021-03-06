# ecs.tf

resource "aws_ecs_cluster" "main" {
  name = "cb-cluster"
  depends_on = [aws_db_instance.rds]
}

data "template_file" "cb_app" {
  template = file("./templates/ecs/cb_app.json.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
    db_host        = aws_db_instance.rds.address  
    db_port        = var.db_port
    db_user        = var.db_user
    db_pass        = var.db_pass
    db_name        = var.db_name
    environment    = var.environment
    backend_recaptcha_secret        = var.backend_recaptcha_secret
    jwt_secret        = var.jwt_secret
    backend_web_frontend_url        = var.backend_web_frontend_url
    backend_key_gen_buffer_size     = var.backend_key_gen_buffer_size
    backend_key_gen_hostname        = var.backend_key_gen_hostname
    backend_key_gen_port        = var.backend_key_gen_port
    backend_graphql_api_port        = var.backend_graphql_api_port
    backend_graphql_i_ql_default_query        = var.backend_graphql_i_ql_default_query
    backend_http_api_port        = var.backend_http_api_port
    backend_grpc_api_port        = var.backend_grpc_api_port
    backend_auth_token_lifetime        = var.backend_auth_token_lifetime
    backend_search_api_timeout        = var.backend_search_api_timeout
  }
}

data "template_file" "cb_kgs" {
  template = file("./templates/ecs/cb_kgs.json.tpl")

  vars = {
    app_image             = var.kgs_image
    app_port              = var.kgs_port
    fargate_cpu           = var.fargate_cpu
    fargate_memory        = var.fargate_memory
    aws_region            = var.aws_region
    db_host               = aws_db_instance.rds.address  
    db_port               = var.db_port
    db_user               = var.db_user
    db_pass               = var.db_pass
    kgs_db_name           = var.kgs_db_name
    backend_grpc_api_port = var.backend_grpc_api_port
    kgs_enable_encryption = var.kgs_enable_encryption
  }
}

data "template_file" "cb_frontend" {
  template = file("./templates/ecs/cb_frontend.json.tpl")

  vars = {
    frontend_image      = var.frontend_image
    frontend_port       = var.frontend_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
    environment    = var.environment
    react_app_graphql_api_base_url = var.react_app_graphql_api_base_url
    react_app_http_api_base_url = var.react_app_http_api_base_url

  }
}
resource "aws_ecs_task_definition" "app" {
  family                   = "cb-app-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.cb_app.rendered
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "cb-frontend-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.cb_frontend.rendered
}

resource "aws_ecs_task_definition" "kgs" {
  family                   = "cb-kgs-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.cb_kgs.rendered
}

resource "aws_ecs_service" "main" {
  name            = "cb-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "cb-app"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.app, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_ecs_service" "frontend" {
  name            = "cb-service-frontend"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.frontend.id
    container_name   = "cb-frontend"
    container_port   = var.frontend_port
  }

  depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_ecs_service" "kgs" {
  name            = "cb-service-kgs"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.kgs.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.kgs.id
    container_name   = "cb-kgs"
    container_port   = var.kgs_port
  }

  depends_on = [aws_alb_listener.kgs, aws_iam_role_policy_attachment.ecs_task_execution_role]
}