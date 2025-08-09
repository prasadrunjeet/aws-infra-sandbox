variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1" # Mumbai
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0144277607031eca2" # Amazon Linux 2023 in ap-south-1
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
  default = "jenkin-mumbai-01"
}

variable "instance_name" {
  description = "Name tag for the instance"
  type        = string
  default     = "mcp-01-sandbox"
}

variable "environment" {
  description = "Environment tag (dev, test, prod)"
  type        = string
  default     = "Test"
}

variable "vpc_id" {
  description = "VPC id to use"
  type = string
  default = "vpc-0a49388376778bed7"
}