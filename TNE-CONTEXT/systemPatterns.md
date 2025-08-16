# System Patterns

This file documents recurring patterns and standards used in the project.
It is optional, but recommended to be updated as the project evolves.
2025-08-16 18:02:59 - Log of updates made.

## Coding Patterns

* Environment-driven configuration using AWS Secrets Manager
* Container-first deployment with multi-variant Docker images (lite, full, ollama)
* Health check endpoints on application port 7860
* Persistent data storage in /app/ktem_app_data via EFS mounting

## Architectural Patterns

* Serverless container orchestration with AWS ECS Fargate
* Multi-AZ deployment for high availability (us-west-2a, us-west-2b)
* Application Load Balancer with health checks for traffic distribution
* Auto-scaling based on resource utilization thresholds
* Separation of concerns: VPC networking, container services, storage, secrets

## Testing Patterns

* CI/CD pipeline with build, test, and deploy stages
* Smoke tests against deployed application endpoints
* Container image vulnerability scanning
* Infrastructure validation with Terraform plan/apply