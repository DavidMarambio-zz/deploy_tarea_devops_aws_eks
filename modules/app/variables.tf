variable "eks" {
  description = "EKS cluster"
}

variable "nodes_group" {
  description = "EKS cluster nodes group"
}

variable "name" {
  description = "Project name"
}

variable "app_name" {
  description = "Application name"
}

variable "namespace" {
  description = "Namespace of the Project"
}

variable "secret_key" {
  description = "App Secret Key"
}

variable "docker_image" {
  description = "App container image"
}