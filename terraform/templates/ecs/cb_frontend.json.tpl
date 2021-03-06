[
  {
    "name": "cb-frontend",
    "image": "${frontend_image}",
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
        "containerPort": ${frontend_port},
        "hostPort": ${frontend_port}
      }
    ],
    "environment": [
      {
        "name": "REACT_APP_GRAPHQL_API_BASE_URL",
        "value": "${react_app_graphql_api_base_url}"
      },
      {
        "name": "REACT_APP_HTTP_API_BASE_URL",
        "value": "${react_app_http_api_base_url}"
      }
    ]
  }
]
