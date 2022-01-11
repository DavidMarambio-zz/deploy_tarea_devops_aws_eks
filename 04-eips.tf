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