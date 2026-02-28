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

variable "jenkins_key_pair_name" {
  description = "Name of your existing EC2 key pair for SSH access to Jenkins"
  type        = string
  default     = "cyberkey"
}

variable "jenkins_allowed_cidr" {
  description = "CIDR allowed to access Jenkins UI (port 8080) and SSH (port 22)"
  type        = string
  default     = "0.0.0.0/0" # Restrict to your IP for better security: "x.x.x.x/32"
}