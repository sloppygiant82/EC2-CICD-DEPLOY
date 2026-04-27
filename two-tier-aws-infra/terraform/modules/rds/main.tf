resource "aws_db_subnet_group" "db_subnet" {
    name = "db-subnet-group"
    subnet_ids = var.private_subnets
}

resource "aws_db_instance" "db" {
   allocated_storage    =  20
   engine               = "mysql"
   engine_version       = "8.0"
   instance_class       = "db.t3.micro"
   db_name              = "appdb"
   username             = "admin"
   password             = var.db_password
   db_subnet_group_name = aws_db_subnet_group.db_subnet.name
   skip_final_snapshot  = true

   vpc_security_group_ids = [var.db_security_group_id]
}
   