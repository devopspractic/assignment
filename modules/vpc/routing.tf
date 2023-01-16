resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags{
    Name = "public"
  }
}
resource "aws_route_table" "privateroute1"{
 vpc_id = aws_vpc.main.id

 route{
   cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.gwt1.id
 }
 tags{
   Name = "private-1"
 }
}

resource "aws_route_table" "privateroute2"{
 vpc_id = aws_vpc.main.id

 route{
   cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.gwt2.id
 }
 tags{
   Name = "private-1"
 }
}

resource "aws_route_table_association" "public1" {
 subnet_id = aws_subnet.public_1.id
 route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2"{
 subnet_id = aws_subnet.public_2.id
 route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private1"{
 subnet_id = aws_subnet.private_1.id
 route_table_id = aws_route_table.privateroute1.id
}
resource "aws_route_table_association" "private2"{
 subnet_id = aws_subnet.private_2.id
 route_table_id = aws_route_table.privateroute2.id
}
