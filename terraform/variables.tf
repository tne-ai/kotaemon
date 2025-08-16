# Terraform Variables for Kotaemon RAG Application Deployment
# AWS ECS Fargate deployment with complete infrastructure

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "kotaemon"
}

variable "environment" {
  description = "Environment name (e.g., prod, staging, dev)"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for multi-AZ deployment"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# ECS Configuration
variable "ecs_task_cpu" {
  description = "CPU units for ECS task (1024 = 1 vCPU)"
  type        = number
  default     = 2048
}

variable "ecs_task_memory" {
  description = "Memory in MiB for ECS task"
  type        = number
  default     = 4096
}

variable "ecs_min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
  default     = 1
}

variable "ecs_max_capacity" {
  description = "Maximum number of ECS tasks"
  type        = number
  default     = 5
}

variable "ecs_desired_capacity" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "cpu_target_utilization" {
  description = "Target CPU utilization for auto-scaling"
  type        = number
  default     = 70
}

variable "memory_target_utilization" {
  description = "Target memory utilization for auto-scaling"
  type        = number
  default     = 80
}

# Application Configuration
variable "container_image" {
  description = "Docker image for the application (will be updated by CI/CD)"
  type        = string
  default     = "ghcr.io/cinnamon/kotaemon:main-lite"
}

variable "container_port" {
  description = "Port on which the application runs"
  type        = number
  default     = 7860
}

variable "health_check_path" {
  description = "Health check path for the application"
  type        = string
  default     = "/"
}

# Secrets (no default values for security)
variable "openai_api_key" {
  description = "OpenAI API key for the application"
  type        = string
  sensitive   = true
}

variable "cohere_api_key" {
  description = "Cohere API key for the application"
  type        = string
  sensitive   = true
}

# ECR Configuration
variable "ecr_image_retention_count" {
  description = "Number of Docker images to retain in ECR"
  type        = number
  default     = 10
}

# EFS Configuration
variable "efs_backup_retention_days" {
  description = "Number of days to retain EFS backups"
  type        = number
  default     = 30
}

# Tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "kotaemon"
    Environment = "prod"
    ManagedBy   = "terraform"
    Application = "rag-application"
  }
}