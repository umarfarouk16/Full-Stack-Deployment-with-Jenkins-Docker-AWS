variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "techpathway"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "availability_zones" {
  description = "AZs for high availability"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Why multiple AZs? ECS requires at least 2 for load balancing