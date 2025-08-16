## 🚀 Deployment Plan & Prompt for Coding Stage

### 1. Project Summary
- **Application Type:** Python-based RAG (Retrieval-Augmented Generation) Application with Gradio Frontend and Multi-LLM Integration
- **Primary Goal:** Deploy a scalable, production-ready Kotaemon application with high availability, monitoring, and CI/CD pipeline to AWS.

### 2. Deployment Target
- **Cloud Provider:** AWS
- **Region:** us-west-2 (Oregon)
- **Chosen Service:** AWS ECS with Fargate
- **Justification:** ECS with Fargate is chosen because the project has a sophisticated containerized architecture with complex dependencies (multiple AI/ML libraries, vector stores, custom kotaemon libraries), making it unsuitable for simple PaaS solutions. Fargate provides serverless container orchestration with automatic scaling and high availability without infrastructure management overhead.

### 3. Infrastructure as Code (IaC) Requirements
- **IaC Tool:** Terraform
- **Core Components to Provision:**
    - **Container Orchestration Service:**
        - Configure AWS ECS Cluster with Fargate capacity providers
        - Create ECS Service with auto-scaling rules: min 1 task, max 5 tasks, based on CPU utilization > 70% and memory utilization > 80%
        - Deploy using the existing `lite` Docker variant for optimal performance
        - Configure health checks using Gradio's default port 7860
        - Define necessary environment variables: `OPENAI_API_KEY`, `COHERE_API_KEY`, `GRADIO_SERVER_NAME=0.0.0.0`, `GRADIO_SERVER_PORT=7860`, `KH_FEATURE_USER_MANAGEMENT=true`
    - **Container Registry:**
        - Provision Amazon ECR repository for storing Docker images
        - Configure lifecycle policies to retain only the latest 10 images
    - **Load Balancing:**
        - Create Application Load Balancer (ALB) with health checks on port 7860
        - Configure target group for ECS service with health check path `/`
        - Set up ALB security group allowing HTTP/HTTPS traffic
    - **Storage:**
        - Create EFS (Elastic File System) for persistent storage of application data (`/app/ktem_app_data`)
        - Configure EFS access points and mount targets in private subnets
        - Set up automated daily backups using AWS Backup
    - **Networking:**
        - Create a new VPC with public and private subnets across 2 availability zones
        - Configure NAT Gateway for outbound internet access from private subnets
        - Set up VPC endpoints for ECR, ECS, and CloudWatch for secure communication
    - **Secrets Management:**
        - Create secrets in AWS Secrets Manager for: `OPENAI_API_KEY`, `COHERE_API_KEY`
        - Configure ECS task execution role with permissions to read secrets
        - Set up IAM roles for ECS tasks with least-privilege access

### 4. CI/CD Pipeline Requirements (GitHub Actions)
- **File Name:** `.github/workflows/deploy.yml`
- **Trigger:** On push to the `main` branch
- **Jobs & Steps:**
    1. **`build` Job:**
        - Check out the code
        - Set up Python 3.10+ environment
        - Install dependencies from `pyproject.toml`
        - Run linting with pre-commit hooks
        - Run unit tests if available
        - Configure AWS credentials using GitHub Secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
        - Build, tag, and push Docker image to Amazon ECR using the lite variant
        - Tag images with both `latest` and commit SHA for versioning
    2. **`deploy` Job (depends on `build`):**
        - Configure AWS credentials using GitHub Secrets
        - Check out the code
        - Initialize and apply Terraform configuration
        - Update ECS service with new task definition pointing to the new image
        - Wait for deployment completion and health checks
        - Perform basic smoke tests against the deployed application

### 5. Assumptions & Clarifications
- The user confirmed using AWS us-west-2 region for West Coast users
- SQLite + ChromaDB file-based storage will be used, requiring EFS for persistence across container restarts
- OpenAI API and Cohere API are the primary external dependencies requiring secure secret management
- The existing Docker `lite` variant will be used for production deployment as specified in the codebase
- High availability is achieved through multi-AZ deployment with auto-scaling between 1-5 tasks
- The application will use default AWS-provided URLs initially, with custom domain support available for future enhancement
- All persistent application data will be stored in `/app/ktem_app_data` mounted from EFS
- User management features will be enabled in production (`KH_FEATURE_USER_MANAGEMENT=true`)
- The deployment assumes the existing codebase structure with libs/kotaemon and libs/ktem submodules
- Monitoring and logging will be configured using CloudWatch for production observability