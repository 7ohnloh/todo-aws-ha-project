resource "aws_db_subnet_group" "main" {
  name       = "${local.common_name}-db-subnets"
  subnet_ids = aws_subnet.public[*].id

  tags = { Name = "${local.common_name}-db-subnets" }
}

resource "aws_db_instance" "main" {
  identifier = "${local.common_name}-mysql"

  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  max_allocated_storage  = 50
  storage_type           = "gp3"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  port                   = 3306
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false

  multi_az                = var.db_multi_az
  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = { Name = "${local.common_name}-mysql" }
}
