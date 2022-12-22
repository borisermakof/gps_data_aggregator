locals {
  env_prefix = var.env

  # VPC block
  cidr_block               = "${var.vpc_cidr_class_a}.${var.vpc_cidr_class_b}.0.0/16"
  private_subnets_cidrs    = ["${var.vpc_cidr_class_a}.${var.vpc_cidr_class_b}.1.0/24", "${var.vpc_cidr_class_a}.${var.vpc_cidr_class_b}.2.0/24", "${var.vpc_cidr_class_a}.${var.vpc_cidr_class_b}.3.0/24"]
  public_subnets_cidrs     = ["${var.vpc_cidr_class_a}.${var.vpc_cidr_class_b}.101.0/24", "${var.vpc_cidr_class_a}.${var.vpc_cidr_class_b}.102.0/24", "${var.vpc_cidr_class_a}.${var.vpc_cidr_class_b}.103.0/24"]
  private_subnets          = coalescelist(var.private_subnets, slice(local.private_subnets_cidrs, 0, var.number_of_availability_zones))
  public_subnets           = coalescelist(var.public_subnets, slice(local.public_subnets_cidrs, 0, var.number_of_availability_zones))
  availability_zones_names = coalescelist(var.availability_zones_names, data.aws_availability_zones.available.names)

  # Lambda block
  lambda_output_zip  = "${path.module}/lambdas/output/"
  lambda_source_path = "${path.module}/lambdas"

  dymano_table_name = "regions_data"
  tags = {
    "Name"        = "${local.env_prefix}-vpc",
    "Environment" = var.env
  }
}
