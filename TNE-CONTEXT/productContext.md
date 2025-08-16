# Product Context

This file provides a high-level overview of the project and the expected product that will be created. Initially it is based upon projectBrief.md (if provided) and all other available project-related information in the working directory. This file is intended to be updated as the project evolves, and should be used to inform all other modes of the project's goals and context.

2025-08-16 18:01:48 - Initial TNE Context setup for Kotaemon RAG Application deployment project

## Project Goal

Deploy a scalable, production-ready Kotaemon RAG (Retrieval-Augmented Generation) application with high availability, monitoring, and CI/CD pipeline to AWS using proper Infrastructure as Code practices.

## Key Features

- Python-based RAG application with Gradio frontend
- Multi-LLM integration (OpenAI, Cohere, Azure OpenAI, Ollama, etc.)
- Multi-modal document parsing and processing
- Advanced retrieval capabilities including GraphRAG
- SQLite + ChromaDB file-based storage with EFS persistence
- User management and authentication features
- Container-first deployment using AWS ECS with Fargate
- Automated CI/CD pipeline with GitHub Actions

## Overall Architecture

- **Frontend**: Gradio-based web interface on port 7860
- **Backend**: Python application with FastAPI integration
- **Storage**: AWS EFS for persistent data, ECR for container images
- **Orchestration**: AWS ECS with Fargate for serverless container management
- **Load Balancing**: Application Load Balancer with health checks
- **Networking**: Custom VPC with public/private subnets across 2 AZs
- **Secrets**: AWS Secrets Manager for API keys
- **Deployment**: Terraform for IaC, GitHub Actions for CI/CD

2025-08-16 18:01:48 - Log of updates made will be appended as footnotes to the end of this file.