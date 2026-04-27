output "sg_id" {
  value = aws_security_group.main.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}
