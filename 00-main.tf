provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  cluster_name = "learning-eks-${random_string.suffix.result}"
}