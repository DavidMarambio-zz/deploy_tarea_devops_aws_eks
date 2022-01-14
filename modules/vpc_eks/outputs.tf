output "vpc" {
  value       = aws_vpc.main
  description = "AWS VPC"
}

output "subnet_public_1" {
  value       = aws_subnet.public-1
  description = "AWS Subnet Public 1"
}

output "subnet_public_2" {
  value       = aws_subnet.public-2
  description = "AWS Subnet Public 2"
}

output "subnet_private_1" {
  value       = aws_subnet.private-1
  description = "AWS Subnet Private 1"
}

output "subnet_private_2" {
  value       = aws_subnet.private-2
  description = "AWS Subnet Private 2"
}