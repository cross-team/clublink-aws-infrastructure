[
  {
    "name": "cb-kgs",
    "image": "${kgs_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/cb-app",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${kgs_port},
        "hostPort": ${kgs_port}
      }
    ],
    "environment": [
      {
        "name": "DB_HOST",
        "value": "${db_host}"
      },
      {
        "name": "DB_PORT",
        "value": "${db_port}"
      },
      {
        "name": "DB_USER",
        "value": "${db_user}"
      },
      {
        "name": "DB_PASSWORD",
        "value": "${db_pass}"
      },
      {
        "name": "DB_NAME",
        "value": "${kgs_db_name}"
      },
      {
        "name": "ENABLE_ENCRYPTION",
        "value": "${kgs_enable_encryption}"
      },
      {
        "name": "GRPC_API_PORT",
        "value": "${backend_grpc_api_port}"
      },
    ]
  }
]
