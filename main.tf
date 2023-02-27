module "network" {
  source          = "./Network"
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  env             = var.env
  map_public_ip_on_launch = var.map_public_ip_on_launch
  project         = var.project
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "bastion_host" {
  source        = "./Bastion"
  ami           = var.ami
  env           = var.env
  project       = var.project
  instance_type = var.instance_type
  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.public_subnet
  key_name      = var.key_name
}

module "autoscaling" {
  source            = "./autoscaling"
  env               = var.env
  cidr_blocks       = [module.alb.alb_sg, module.bastion_host.bastion_sg]
  vpc_id            = module.network.vpc_id
  project           = var.project
  ami               = var.ami
  instance_type     = var.instance_type
  lb_subnets        = module.network.private_subnets
  min_size          = var.min_size
  max_size          = var.max_size
  target_group_arns = module.alb.target_group

}

module "alb" {
  source      = "./alb"
  cidr_blocks = module.bastion_host.bastion_sg
  lb_subnets  = module.network.private_subnets
  project     = var.project
  env         = var.env
  vpc_id      = module.network.vpc_id
}

module "s3" {
  source = "./s3bucket"
  project     = var.project
  env         = var.env
  storage_class = var.storage_class
  transition_day = var.transition_day
  //key = "${each.key}"
}