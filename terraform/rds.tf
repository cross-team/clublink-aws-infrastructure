# RDS Instance
resource "aws_db_instance" "rds" {
  identifier             = "clublink-db"
  allocated_storage      = "25"
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.2"
  instance_class         = "db.t2.small"
  name                   = var.db_name
  username               = var.db_user
  password               = var.db_pass
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  deletion_protection    = false
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.private_subnet.*.id

  tags = {
    Name = "rds-subnet-group"
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = "5432"
    to_port         = "5432"
    protocol        = "TCP"
    security_groups = [aws_security_group.rds_access_sg.id, aws_security_group.ecs_tasks.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# RDS Ingress Security Group
resource "aws_security_group" "rds_access_sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "rds-acess-sg"

  tags = {
    Name = "rds-access-sg"
  }
}   