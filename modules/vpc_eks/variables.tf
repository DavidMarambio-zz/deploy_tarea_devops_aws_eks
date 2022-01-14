variable "cidr" {
  default     = "192.168.0.0/16"
  description = "CIDR blocks"
}

variable "cidr_public_1" {
  default     = "192.168.0.0/18"
  description = "CIDR blocks for the subnet public_1"
}

variable "az_public_1" {
  default     = "us-east-1a"
  description = "Availability zone for the subnet public_1"
}

variable "cidr_public_2" {
  default     = "192.168.64.0/18"
  description = "CIDR blocks for the subnet public_2"
}

variable "az_public_2" {
  default     = "us-east-1b"
  description = "Availability zone for the subnet public_2"
}

variable "cidr_private_1" {
  default     = "192.168.128.0/18"
  description = "CIDR blocks for the subnet private_1"
}

variable "az_private_1" {
  default     = "us-east-1a"
  description = "Availability zone for the subnet private_1"
}

variable "cidr_private_2" {
  default     = "192.168.192.0/18"
  description = "CIDR blocks for the subnet private_2"
}

variable "az_private_2" {
  default     = "us-east-1b"
  description = "Availability zone for the subnet private_2"
}

variable "cluster_name" {
  description = "Name of the clustes EKS"
}