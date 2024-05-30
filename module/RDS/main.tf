data "aws_rds_engine_version" "rds_enginer" {
  engine = "mysql"
  version = "8.0.35"
}

data "aws_availability_zones" "aws_availability_zones" {
  state = "available"
}

resource "aws_db_subnet_group" "tf_subnet_groups" {
  name = "${var.project_name}-tf-subnet-groups"
  subnet_ids = [var.private_subnet_1a, var.private_subnet_1b, var.private_subnet_1c]
  tags = {
    Name = "${var.project_name}-subnet-groups"
  }
}

resource "aws_rds_cluster" "tf_rds_cluster" {
  cluster_identifier = "tf-rds-cluster"
  availability_zones = [ data.aws_availability_zones.aws_availability_zones.names[0], data.aws_availability_zones.aws_availability_zones.names[1], data.aws_availability_zones.aws_availability_zones.names[2] ]
  engine = data.aws_rds_engine_version.rds_enginer.engine
  engine_version = data.aws_rds_engine_version.rds_enginer.version
  db_cluster_instance_class = "db.m5d.large"
  
  db_subnet_group_name = aws_db_subnet_group.tf_subnet_groups.name
  vpc_security_group_ids = [var.tf_sg_rds]

  skip_final_snapshot = true
  storage_type = "io1"
  allocated_storage = 100
  iops = 1000
  apply_immediately = true
  backup_retention_period = 7

  database_name   = "devopsvn"
  master_password = var.password
  master_username = "lmduccloud"
  
}