resource "aws_eip" "nat" {
    tags = {
        Name = "nat-eip"
    }
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id     = var.public_subnet_id

    tags = {
        Name = "nat-gateway"
    }
}

resource "aws_route_table" "private_rt" {
    vpc_id = var.vpc_id

    tags = {
        Name = "private-rt"
    }
}

resource "aws_route" "private_internet" {
    route_table_id         = aws_route_table.private_rt.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_rt_association" {
    subnet_id      = var.private_subnet_id
    route_table_id = aws_route_table.private_rt.id
}
