# 🚀 Kotaemon RAG Application - Production Deployment Guide

## Overview

This document provides complete instructions for deploying the Kotaemon RAG application to AWS using the proper Infrastructure as Code (IaC) approach with Terraform and GitHub Actions CI/CD pipeline.

## Architecture Summary

- **Cloud Provider**: AWS (us-west-2 region)
- **Container Platform**: AWS ECS with Fargate
- **Load Balancer**: Application Load Balancer (ALB)
- **Storage**: AWS EFS for persistent data, ECR for container images
- **Networking**: Custom VPC with public/private subnets across 2 AZs
- **Secrets**: AWS Secrets Manager for API keys
- **Auto-scaling**: 1-5 tasks based on CPU > 70% and memory > 80%
- **Monitoring**: CloudWatch logs and metrics
- **Backup**: Automated daily EFS backups

## Prerequisites

### 1. AWS Account Setup

- AWS account with appropriate permissions
- AWS CLI installed and configured
- Terraform >= 1.0 installed

### 2. GitHub Repository Setup

Ensure your repository contains:
- All Kotaemon application code
- The infrastructure files created by this deployment
- Git submodules properly configured

### 3. Required GitHub Secrets

Configure the following secrets in your GitHub repository (`Settings > Secrets and variables > Actions`):

```
AWS_ACCESS_KEY_ID          - AWS access key for deployment
AWS_SECRET_ACCESS_KEY      - AWS secret key for deployment
OPENAI_API_KEY            - OpenAI API key for the application
COHERE_API_KEY            - Cohere API key for the application
```

## File Structure

After running this deployment setup, you will have:

```
.
├── terraform/
│   ├── variables.tf       # Configurable parameters
│   ├── main.tf           # Complete AWS infrastructure
│   └── outputs.tf        # Deployment endpoints and info
├── .github/
│   └── workflows/
│       └── deploy.yml    # CI/CD pipeline
├── deployment-details.md # Original deployment specifications
├── code-details.md      # Code review and analysis
└── DEPLOYMENT.md        # This deployment guide
```

## Deployment Steps

### Step 1: Initial Setup

1. **Clone and prepare repository**:
```bash
git clone <your-repo-url>
cd kotaemon
git submodule update --init --recursive
```

2. **Verify AWS credentials**:
```bash
aws sts get-caller-identity
```

3. **Initialize Terraform** (optional for manual deployment):
```bash
cd terraform
terraform init
```

### Step 2: Configure Secrets

1. **Set up AWS Secrets Manager values**:
   - The Terraform configuration will create secrets in AWS Secrets Manager
   - API keys will be stored securely and accessed by the application

2. **Verify GitHub secrets**:
   - Ensure all required secrets are configured in GitHub
   - Test access by running a workflow dispatch if needed

### Step 3: Deploy Infrastructure

#### Option A: Automated Deployment (Recommended)

1. **Push to main branch**:
```bash
git add .
git commit -m "Add production deployment configuration"
git push origin main
```

2. **Monitor deployment**:
   - Go to GitHub Actions tab
   - Watch the "Deploy Kotaemon RAG Application" workflow
   - Check for successful completion of all jobs

#### Option B: Manual Deployment

1. **Plan infrastructure**:
```bash
cd terraform
export TF_VAR_openai_api_key="your-openai-key"
export TF_VAR_cohere_api_key="your-cohere-key"
terraform plan
```

2. **Apply infrastructure**:
```bash
terraform apply
```

3. **Note the outputs**:
```bash
terraform output
```

### Step 4: Verify Deployment

1. **Get application URL**:
```bash
cd terraform
terraform output application_url
```

2. **Test application**:
```bash
curl -f "$(terraform output -raw application_url)"
```

3. **Check health status**:
   - Visit the application URL in your browser
   - Verify the Gradio interface loads correctly
   - Test basic functionality

## Configuration Options

### Environment Variables

The application uses these key environment variables:

- `GRADIO_SERVER_NAME=0.0.0.0` - Server binding
- `GRADIO_SERVER_PORT=7860` - Application port
- `KH_FEATURE_USER_MANAGEMENT=true` - Enable user management
- `OPENAI_API_KEY` - Retrieved from Secrets Manager
- `COHERE_API_KEY` - Retrieved from Secrets Manager

### Terraform Variables

Key configurable parameters in [`terraform/variables.tf`](terraform/variables.tf):

- `aws_region` - AWS deployment region (default: us-west-2)
- `ecs_task_cpu` - CPU units for containers (default: 2048)
- `ecs_task_memory` - Memory in MiB (default: 4096)
- `ecs_min_capacity` - Minimum task count (default: 1)
- `ecs_max_capacity` - Maximum task count (default: 5)
- `cpu_target_utilization` - CPU scaling threshold (default: 70%)
- `memory_target_utilization` - Memory scaling threshold (default: 80%)

### Customization

To modify the deployment:

1. **Adjust resources**: Edit [`terraform/variables.tf`](terraform/variables.tf)
2. **Change scaling**: Modify auto-scaling parameters
3. **Update environment**: Add new environment variables in [`terraform/main.tf`](terraform/main.tf)

## Monitoring and Maintenance

### CloudWatch Logs

Application logs are available in CloudWatch:
- Log group: `/ecs/kotaemon-prod`
- Stream prefix: `ecs`

### Monitoring Metrics

Key metrics to monitor:
- ECS service CPU and memory utilization
- ALB target health
- EFS performance metrics
- Application response times

### Backup and Recovery

- **EFS Backups**: Automated daily backups with 30-day retention
- **Image Backups**: ECR lifecycle policy retains latest 10 images
- **Infrastructure**: Terraform state for infrastructure recovery

## Troubleshooting

### Common Issues

1. **Deployment fails with permission errors**:
   - Verify AWS credentials have required permissions
   - Check GitHub secrets are correctly configured

2. **Application not accessible**:
   - Check ALB target group health
   - Verify security group rules
   - Review ECS service events

3. **Container startup issues**:
   - Check CloudWatch logs for application errors
   - Verify environment variables are set correctly
   - Ensure secrets are accessible

4. **Scaling issues**:
   - Monitor CloudWatch metrics
   - Adjust auto-scaling thresholds if needed
   - Check ECS cluster capacity

### Debug Commands

```bash
# Check ECS service status
aws ecs describe-services --cluster kotaemon-prod --services kotaemon-prod

# View task details
aws ecs describe-tasks --cluster kotaemon-prod --tasks <task-arn>

# Check ALB target health
aws elbv2 describe-target-health --target-group-arn <target-group-arn>

# View CloudWatch logs
aws logs describe-log-streams --log-group-name /ecs/kotaemon-prod
```

## Security Considerations

1. **API Keys**: Stored in AWS Secrets Manager, never in code
2. **Network Security**: Application runs in private subnets
3. **Access Control**: ALB provides public access, ECS tasks are private
4. **Encryption**: EFS encrypted at rest, secrets encrypted in transit
5. **Image Scanning**: ECR vulnerability scanning enabled

## Cost Optimization

1. **Use FARGATE_SPOT** for non-critical workloads
2. **Adjust auto-scaling parameters** based on usage patterns
3. **Monitor CloudWatch** for optimization opportunities
4. **Review EFS provisioned throughput** requirements

## Cleanup

To remove all infrastructure:

```bash
cd terraform
terraform destroy
```

**⚠️ Warning**: This will permanently delete all infrastructure and data.

## Support and Documentation

- **Infrastructure Code**: [`terraform/`](terraform/) directory
- **CI/CD Pipeline**: [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml)
- **Application Code**: Main repository and submodules
- **Architecture Details**: [`deployment-details.md`](deployment-details.md)
- **Code Analysis**: [`code-details.md`](code-details.md)

## Next Steps

After successful deployment:

1. **Configure custom domain** (optional)
2. **Set up monitoring alerts**
3. **Review and tune auto-scaling parameters**
4. **Plan backup and disaster recovery procedures**
5. **Implement additional security hardening as needed**

---

**🎉 Deployment Complete!**

Your Kotaemon RAG application is now running in production on AWS with:
- High availability across multiple availability zones
- Auto-scaling based on demand
- Secure secrets management
- Automated backups
- Comprehensive monitoring
- CI/CD pipeline for future updates

For any issues or questions, refer to the troubleshooting section above or review the CloudWatch logs for detailed error information.