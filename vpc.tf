# Create a VPC

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${local.env_prefix}-vpc"
  cidr = local.cidr_block

  azs             = slice(local.availability_zones_names, 0, var.number_of_availability_zones)
  private_subnets = slice(local.private_subnets, 0, var.number_of_availability_zones)
  public_subnets  = slice(local.public_subnets, 0, var.number_of_availability_zones)

  enable_dns_hostnames = true
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  reuse_nat_ips        = false

  map_public_ip_on_launch = true
  enable_vpn_gateway      = false

  #database_subnets = slice(local.database_subnets, 0, var.number_of_availability_zones)

  #database_subnet_tags = {
  #  Name        = var.database_subnet_name == "" ? "${local.name_prefix}-db-net" : var.database_subnet_name
  #  Environment = var.env
  #  Group       = local.billing_tag
  #}

  public_subnet_tags = {
    "Name" = "${local.env_prefix}-public-net",
  }

  private_subnet_tags = {
    "Name" = "${local.env_prefix}-private-net",
  }

  vpc_tags = {
    "Name" = "${local.env_prefix}-vpc",
  }

  tags = {
    "Name" = "${local.env_prefix}-vpc",
  }
}
