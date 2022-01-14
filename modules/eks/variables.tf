variable "cluster_name" {
  default = "Name of the Cluster EKS"
}

variable "kubernetes_version" {
  default = "Kubernetes version"
}

variable "subnet_public_1_id" {
  description = "Subnet ID for public network 1"
}

variable "subnet_public_2_id" {
  description = "Subnet ID for public network 2"
}

variable "subnet_private_1_id" {
  description = "Subnet ID for private network 1"
}

variable "subnet_private_2_id" {
  description = "Subnet ID for private network 2"
}

variable "vpc" {
  description = "VPC for EKS Cluster"
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes"
  default     = 5
}

variable "instance_types" {
  description = "Instance types EC2"
}