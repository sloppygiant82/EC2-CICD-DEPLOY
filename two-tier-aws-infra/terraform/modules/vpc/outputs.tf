output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the first private subnet"
  value       = aws_subnet.private.id
}

output "private_subnet_id_2" {
  description = "ID of the second private subnet"
  value       = aws_subnet.private_2.id
}
