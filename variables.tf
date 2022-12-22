variable "region" {
  default = "eu-central-1"
}

variable "env" {
  description = "environment name"
}

variable "vpc_cidr_class_a" {
  description = "VPC CIDR Class A"
  default     = 10
}

variable "vpc_cidr_class_b" {
  description = "VPC CIDR Class B"
  default     = 0
}

variable "number_of_availability_zones" {
  description = "Number of avaliability zones to deploy"
  default     = 3
}

variable "availability_zones_names" {
  description = "AWS availablity zones to use"
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets CIDRs inside the VPC. All CIDRs should be within CIDR Address from VPC (e.g. vpc_cidr_class_a.vpc_cidr_class_b.X.Y/Z)"
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets CIDRs inside the VPC. All CIDRs should be within CIDR Address from VPC (e.g. vpc_cidr_class_a.vpc_cidr_class_b.X.Y/Z)"
  default     = []
}

variable "enable_nat_gateway" {
  description = "Create NAT gateways"
  default     = true
}

variable "single_nat_gateway" {
  description = "Create only one NAT gateway for all availability zones"
  default     = false
}
