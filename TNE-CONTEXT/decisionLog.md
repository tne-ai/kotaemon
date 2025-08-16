# Decision Log

This file records architectural and implementation decisions using a list format.
2025-08-16 18:02:43 - Log of updates made.

## Decision

AWS ECS with Fargate chosen for container orchestration

## Rationale 

ECS with Fargate provides serverless container orchestration with automatic scaling and high availability without infrastructure management overhead. The Kotaemon application has sophisticated containerized architecture with complex dependencies (multiple AI/ML libraries, vector stores, custom kotaemon libraries), making it unsuitable for simple PaaS solutions.

## Implementation Details

- Region: us-west-2 (Oregon) for West Coast users
- Auto-scaling: 1-5 tasks based on CPU > 70% and memory > 80%  
- Health checks: Gradio default port 7860
- Persistent storage: EFS for /app/ktem_app_data
- Container registry: Amazon ECR with lifecycle policies
- Load balancing: Application Load Balancer with health checks
- Secrets management: AWS Secrets Manager for API keys