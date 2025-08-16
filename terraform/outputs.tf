# Terraform Outputs for Kotaemon RAG Application Deployment
# Provides key endpoints and resource information after deployment

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "application_url" {
  description = "URL of the deployed Kotaemon application"
  value       = "http://${aws_lb.main.dns_name}"
}

output "load_balancer_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "load_balancer_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "load_balancer_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app.name
}

output "ecs_service_arn" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.app.id
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.app.arn
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.app.repository_url
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.app.name
}

output "efs_file_system_id" {
  description = "ID of the EFS file system"
  value       = aws_efs_file_system.app_data.id
}

output "efs_file_system_arn" {
  description = "ARN of the EFS file system"
  value       = aws_efs_file_system.app_data.arn
}

output "efs_access_point_id" {
  description = "ID of the EFS access point"
  value       = aws_efs_access_point.app_data.id
}

output "efs_access_point_arn" {
  description = "ARN of the EFS access point"
  value       = aws_efs_access_point.app_data.arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs.arn
}

output "secrets_manager_openai_secret_arn" {
  description = "ARN of the OpenAI API key secret in Secrets Manager"
  value       = aws_secretsmanager_secret.openai_api_key.arn
  sensitive   = true
}

output "secrets_manager_cohere_secret_arn" {
  description = "ARN of the Cohere API key secret in Secrets Manager"
  value       = aws_secretsmanager_secret.cohere_api_key.arn
  sensitive   = true
}

output "backup_vault_name" {
  description = "Name of the AWS Backup vault"
  value       = aws_backup_vault.efs.name
}

output "backup_plan_id" {
  description = "ID of the AWS Backup plan"
  value       = aws_backup_plan.efs.id
}

output "security_group_alb_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "security_group_ecs_tasks_id" {
  description = "ID of the ECS tasks security group"
  value       = aws_security_group.ecs_tasks.id
}

output "security_group_efs_id" {
  description = "ID of the EFS security group"
  value       = aws_security_group.efs.id
}

output "nat_gateway_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "autoscaling_target_resource_id" {
  description = "Resource ID of the autoscaling target"
  value       = aws_appautoscaling_target.ecs_target.resource_id
}

output "task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task.arn
}

# Deployment Information
output "deployment_region" {
  description = "AWS region where resources are deployed"
  value       = var.aws_region
}

output "deployment_environment" {
  description = "Environment name"
  value       = var.environment
}

output "project_name" {
  description = "Project name"
  value       = var.project_name
}

# Health Check Information
output "health_check_url" {
  description = "URL for application health checks"
  value       = "http://${aws_lb.main.dns_name}${var.health_check_path}"
}

output "container_port" {
  description = "Port on which the application container runs"
  value       = var.container_port
}

# Scaling Configuration
output "autoscaling_min_capacity" {
  description = "Minimum number of ECS tasks"
  value       = var.ecs_min_capacity
}

output "autoscaling_max_capacity" {
  description = "Maximum number of ECS tasks"
  value       = var.ecs_max_capacity
}

output "autoscaling_desired_capacity" {
  description = "Desired number of ECS tasks"
  value       = var.ecs_desired_capacity
}

# Resource Configuration Summary
output "deployment_summary" {
  description = "Summary of the deployed infrastructure"
  value = {
    application_url        = "http://${aws_lb.main.dns_name}"
    region                = var.aws_region
    environment           = var.environment
    project_name          = var.project_name
    ecs_cluster           = aws_ecs_cluster.main.name
    ecr_repository        = aws_ecr_repository.app.repository_url
    vpc_id                = aws_vpc.main.id
    efs_filesystem_id     = aws_efs_file_system.app_data.id
    log_group             = aws_cloudwatch_log_group.ecs.name
    backup_vault          = aws_backup_vault.efs.name
    container_port        = var.container_port
    health_check_path     = var.health_check_path
    min_capacity          = var.ecs_min_capacity
    max_capacity          = var.ecs_max_capacity
    cpu_target            = var.cpu_target_utilization
    memory_target         = var.memory_target_utilization
  }
}