# Resource: aws_subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

resource "aws_subnet" "public_1" {
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
    Name                                          = "public-1-${var.az_public_1}"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }
}

resource "aws_subnet" "public_2" {
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
    Name                                          = "public-2-${var.az_public_2}"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }
}

resource "aws_subnet" "private_1" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = var.cidr_private_1

  # The AZ for the subnet.
  availability_zone = var.az_private_1

  # A map of tags to assign og the resources.
  tags = {
    Name                                          = "private-1-${var.az_private_1}"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

resource "aws_subnet" "private_2" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet.
  cidr_block = var.cidr_private_2

  # The AZ for the subnet.
  availability_zone = var.az_private_2

  # A map of tags to assign og the resources.
  tags = {
    Name                                          = "private-2-${var.az_private_2}"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}