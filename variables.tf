

variable "region" {
  description = "AWS region"
  type        = string
}
variable "availability_zone" {
  description = "availability zone"
  type        = string
}

#PRODUCTION VPC

variable "production_vpc_cidr" {
  description = "CIDR block for production VPC"
  type        = string
}

variable "production_subnet1_cidr" {
  description = "CIDR block for production private subnet 1"
  type        = string
}

variable "production_subnet2_cidr" {
  description = "CIDR block for production private subnet 2"
  type        = string
}

variable "production_subnet3_cidr" {
  description = "CIDR block for production private subnet 3"
  type        = string
}



#NETWORK VPC

variable "network_vpc_cidr" {
  type = string
}

variable "network_public_subnet_cidr" {
  type = string
}

variable "network_private_subnet_cidr" {
  type = string
}

