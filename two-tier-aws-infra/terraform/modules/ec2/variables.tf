variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "security_group" {
  description = "Security group ID to attach to the instance"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}
