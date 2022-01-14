# Resource: aws_vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

resource "aws_vpc" "main" {
  # The CIDR block for the VPC.
  cidr_block = var.cidr

  # Makes you instance shared on the host.
  instance_tenancy = "default"

  # Required for EKS. Enable/Disable DNS support in the VPC.
  enable_dns_support = true

  # Required for EKS. Enable/Disable DNS hostnames in the VPC.
  enable_dns_hostnames = true

  # Enable/Disable ClassicLink for the VPC.
  enable_classiclink = false

  # Enable/Disable ClassicLink DNS support for the VPC.
  enable_classiclink_dns_support = false

  # Requests an Amazon-provider IPv6 CIDR blocks with a /56 prefix lenghts.
  assign_generated_ipv6_cidr_block = false

  # A map of tags to assign og the resources.
  tags = {
    Name = "main"
  }

}

# Resource: aws_internet_gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway

resource "aws_internet_gateway" "main" {
  # The VPC ID to create in.
  vpc_id = aws_vpc.main.id

  # A map of tags to assign og the resources.
  tags = {
    Name = "main"
  }

}

# Resource: aws_subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

resource "aws_subnet" "public-1" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = var.cidr_public_1

  # The AZ for the subnet.
  availability_zone = var.az_public_1

  # Required for the EKS. Instance launched into the subnet should assign
  map_public_ip_on_launch = true

  # A map of tags to assign og the resources.
  tags = {
    Name                                        = "public-1-${var.az_public_1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }
}

resource "aws_subnet" "public-2" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = var.cidr_public_2

  # The AZ for the subnet.
  availability_zone = var.az_public_2

  # Required for the EKS. Instance launched into the subnet should assign
  map_public_ip_on_launch = true

  # A map of tags to assign og the resources.
  tags = {
    Name                                        = "public-2-${var.az_public_2}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }
}

resource "aws_subnet" "private-1" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = var.cidr_private_1

  # The AZ for the subnet.
  availability_zone = var.az_private_1

  # A map of tags to assign og the resources.
  tags = {
    Name                                        = "private-1-${var.az_private_1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

resource "aws_subnet" "private-2" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = var.cidr_private_2

  # The AZ for the subnet.
  availability_zone = var.az_private_2

  # A map of tags to assign og the resources.
  tags = {
    Name                                        = "private-2-${var.az_private_2}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

# Resource: aws_eip
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip

resource "aws_eip" "nat1" {
  # EIP may require IGW to exist prior the association.
  # Use depends_on to set an explicit dependency on the IGW.
  depends_on = [aws_internet_gateway.main]

  # A map of tags to assign og the resources.
  tags = {
    Name = "NAT 1"
  }
}

resource "aws_eip" "nat2" {
  # EIP may require IGW to exist prior the association.
  # Use depends_on to set an explicit dependency on the IGW.
  depends_on = [aws_internet_gateway.main]

  # A map of tags to assign og the resources.
  tags = {
    Name = "NAT 2"
  }
}

# Resource: aws_nat_gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway

resource "aws_nat_gateway" "gw1" {
  # The Allocation ID of the Elastic IP address for the gateway. 
  allocation_id = aws_eip.nat1.id

  # The Subnet ID of the subnet which to place the gateway.
  subnet_id = aws_subnet.public-1.id

  # A map of tags to assign og the resources.
  tags = {
    Name = "NAT 1"
  }
}

resource "aws_nat_gateway" "gw2" {
  # The Allocation ID of the Elastic IP address for the gateway. 
  allocation_id = aws_eip.nat2.id

  # The Subnet ID of the subnet which to place the gateway.
  subnet_id = aws_subnet.public-2.id

  # A map of tags to assign og the resources.
  tags = {
    Name = "NAT 2"
  }
}

# Resource: aws_route_table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table

resource "aws_route_table" "public" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  route {
    # The CIDR block for the route
    cidr_block = "0.0.0.0/0"

    # Identifier of the VPC internet gateway or a virtual private gateway.
    gateway_id = aws_internet_gateway.main.id
  }

  # A map of tags to assign og the resources.
  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private1" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  route {
    # The CIDR block for the route
    cidr_block = "0.0.0.0/0"

    # Identifier of the VPC NAT gateway.
    nat_gateway_id = aws_nat_gateway.gw1.id
  }

  # A map of tags to assign og the resources.
  tags = {
    Name = "private1"
  }
}

resource "aws_route_table" "private2" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  route {
    # The CIDR block for the route
    cidr_block = "0.0.0.0/0"

    # Identifier of the VPC NAT gateway.
    nat_gateway_id = aws_nat_gateway.gw2.id
  }

  # A map of tags to assign og the resources.
  tags = {
    Name = "private2"
  }
}

# Resource: aws_route_table_association
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

resource "aws_route_table_association" "public1" {
  # The Subnet ID to create an association
  subnet_id = aws_subnet.public-1.id

  # The ID of the routing table to associate with.
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  # The Subnet ID to create an association
  subnet_id = aws_subnet.public-2.id

  # The ID of the routing table to associate with.
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  # The Subnet ID to create an association
  subnet_id = aws_subnet.private-1.id

  # The ID of the routing table to associate with.
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private2" {
  # The Subnet ID to create an association
  subnet_id = aws_subnet.private-2.id

  # The ID of the routing table to associate with.
  route_table_id = aws_route_table.private2.id
}
