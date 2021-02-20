[
  {
    "name": "cb-app",
    "image": "${app_image}",
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
        "containerPort": ${app_port},
        "hostPort": ${app_port}
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
        "value": "${db_name}"
      },
      {
        "name": "ENV",
        "value": "${environment}"
      },
      {
        "name": "RECAPTCHA_SECRET",
        "value": "${backend_recaptcha_secret}"
      },
      {
        "name": "JWT_SECRET",
        "value": "${jwt_secret}"
      },
      {
        "name": "WEB_FRONTEND_URL",
        "value": "${backend_web_frontend_url}"
      },
      {
        "name": "KEY_GEN_BUFFER_SIZE",
        "value": "${backend_key_gen_buffer_size}"
      },
      {
        "name": "KEY_GEN_HOSTNAME",
        "value": "${backend_key_gen_hostname}"
      },
      {
        "name": "KEY_GEN_PORT",
        "value": "${backend_key_gen_port}"
      },
      {
        "name": "GRAPHQL_API_PORT",
        "value": "${backend_graphql_api_port}"
      },
      {
        "name": "GRAPH_I_QL_DEFAULT_QUERY",
        "value": "${backend_graphql_i_ql_default_query}"
      },
      {
        "name": "HTTP_API_PORT",
        "value": "${backend_http_api_port}"
      },
      {
        "name": "GRPC_API_PORT",
        "value": "${backend_grpc_api_port}"
      },
      {
        "name": "AUTH_TOKEN_LIFETIME",
        "value": "${backend_auth_token_lifetime}"
      },
      {
        "name": "SEARCH_API_TIMEOUT",
        "value": "${backend_search_api_timeout}"
      }
    ]
  }
]
