variable "public_subnet_id" {
  description = "Public subnet ID for the NAT gateway"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the route table"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID to associate with the NAT route table"
  type        = string
}
