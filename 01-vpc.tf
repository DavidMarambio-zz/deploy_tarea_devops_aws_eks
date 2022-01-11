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