provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "vpc" {
  source = "./module/VPC"
  vpc_cidr           = var.vpc_cidr
  project_name       = var.project_name
  public_subnet_1a   = var.public_subnet_1a
  public_subnet_1b   = var.public_subnet_1b
  public_subnet_1c   = var.public_subnet_1c
  private_subnet_1a  = var.private_subnet_1a
  private_subnet_1b  = var.private_subnet_1b
  private_subnet_1c  = var.private_subnet_1c
}

module "alb" {
  source = "./module/ALB"
  project_name      = var.project_name
  public_subnet_1a  = module.vpc.tf_public_subnet_us_east_1a
  public_subnet_1b  = module.vpc.tf_public_subnet_us_east_1b
  public_subnet_1c  = module.vpc.tf_public_subnet_us_east_1c
  sg_alb            = module.vpc.tf_sg_alb
  target_group_arn  = module.asg.target-groups-arn
}

module "asg" {
  source = "./module/ASG"
  project_name        = var.project_name
  image_id            = var.image_id
  vpc_cidr            = module.vpc.tf_vpc
  public_subnet_1a    = module.vpc.tf_public_subnet_us_east_1a
  public_subnet_1b    = module.vpc.tf_public_subnet_us_east_1b
  public_subnet_1c    = module.vpc.tf_public_subnet_us_east_1c
  private_subnet_1a   = module.vpc.tf_private_subnet_us_east_1a
  private_subnet_1b   = module.vpc.tf_private_subnet_us_east_1b
  load_balancers      = module.alb.tf_alb
  load_balancers_arn  = module.alb.tf_alb_arn
}

module "rds" {
  source = "./module/RDS"
  project_name      = var.project_name
  private_subnet_1a = module.vpc.tf_private_subnet_us_east_1a
  private_subnet_1b = module.vpc.tf_private_subnet_us_east_1b
  private_subnet_1c = module.vpc.tf_private_subnet_us_east_1c
  tf_sg_rds         = module.vpc.tf_sg_rds
  password          = var.password
}
