data "aws_vpc" "ansible_vpc" {
  id = "vpc-0f8d4253c7226aa6a"
}

data "aws_route_table" "ansible_vpc_rt" {
  subnet_id = "subnet-00f23dc50a2b98663" 
}

resource "aws_vpc_peering_connection" "foo" {
  peer_vpc_id   = data.aws_vpc.ansible_vpc.id
  vpc_id        = aws_vpc.default.id
  auto_accept = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  tags = {
  Name        = "Ansible-${var.vpc_name}-Peering"
  }
}

# resource "aws_route" "peering" {
#   route_table_id            = aws_route_table.terraform-public.id
#   destination_cidr_block    = "10.5.0.0/16"
#   vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
#   depends_on                = [aws_route_table.terraform-public]
# }

# resource "aws_route" "peeringfromansible" {
#   route_table_id            = data.aws_route_table.ansible_vpc_rt.id
#   destination_cidr_block    = "10.1.0.0/16"
#   vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
#   depends_on                = [aws_route_table.terraform-public]
# }