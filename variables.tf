### root/variables.tf

variable "region" {
  default = "us-east-1"
}

variable "cidr_block" {
  description = "Provide cidr for vpc"
}

variable "subnet_cidrs" {
  description = "provide cidr for subnet cidr"
  type        = map(list(string))
}

variable "availability_zones" {
  description = "Provide availabilty zone for vpc subnet"
  type        = map(list(string))
}
