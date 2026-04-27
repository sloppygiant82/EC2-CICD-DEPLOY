module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_cidr   = var.private_subnet_cidr
  private_subnet_cidr_2 = var.private_subnet_cidr_2
}

module "ec2" {
  source = "./modules/ec2"

  ami_id         = var.ami_id
  subnet_id      = module.vpc.public_subnet_id
  security_group = module.sg.sg_id
  instance_type  = var.instance_type
  key_name       = var.key_name
}

module "sg" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source               = "./modules/rds"
  private_subnets      = [module.vpc.private_subnet_id, module.vpc.private_subnet_id_2]
  db_security_group_id = module.sg.db_sg_id
  db_password          = var.db_password
}

module "nat_gateway" {
  source            = "./modules/nat_gateway"
  public_subnet_id  = module.vpc.public_subnet_id
  vpc_id            = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
}
