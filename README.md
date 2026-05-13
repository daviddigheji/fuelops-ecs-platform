# fuelops-ecs-platform

Infrastructure-as-code project to deploy a production-style AWS ECS Fargate platform for a fictional fuel operations service (**fuelops**). The goal is to demonstrate how I design, provision, and operate container workloads on AWS using Terraform.

## Architecture overview

Target architecture (MVP):

- AWS Region: eu-west-2 (London)
- VPC with 2 Availability Zones
  - Public subnets for an internet-facing Application Load Balancer (ALB)
  - Private subnets for ECS Fargate tasks
- ECS cluster (Fargate only)
- ECS service running a containerised web/API app
- Application Load Balancer
  - Listener on port 80
  - Target group (IP mode) pointing at the ECS service
- Security groups:
  - ALB SG: allow HTTP (80) from the internet
  - ECS SG: allow app port from ALB SG only
- CloudWatch Logs for container logs

This design follows AWS guidance for running container workloads on Fargate with separate public and private subnets and least-privilege security groups.

## Tech stack

- AWS: ECS (Fargate), ALB, VPC, CloudWatch Logs
- IaC: Terraform
- Language: HCL
- Version control: Git + GitHub

## Repository structure

```text
fuelops-ecs-platform/
├── README.md
├── .gitignore
├── docs/
│   └── architecture.md          # Additional diagrams and notes (TBD)
└── terraform/
    ├── versions.tf              # Required provider and Terraform versions
    ├── provider.tf              # AWS provider configuration
    ├── variables.tf             # Input variables (region, naming, etc.)
    ├── networking.tf            # VPC, subnets, route tables, security groups
    ├── ecs.tf                   # ECS cluster, task definition, service
    ├── alb.tf                   # Application Load Balancer, target group, listener
    ├── main.tf                  # High-level wiring and module composition
    └── outputs.tf               # Useful outputs (ALB DNS, cluster name, etc.)
```

## Usage (planned)

1. Configure AWS credentials with permissions to create VPC, ECS, ALB and related resources.
2. Clone this repository.
3. In the `terraform/` directory:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
4. Access the application using the ALB DNS name output by Terraform.

## Learning focus

This project is part of my cloud engineering learning path. It is designed to show:

- How I structure Terraform code for clarity and reuse.
- How I design a basic but production-style ECS Fargate deployment.
- How I think about networking, security groups, and operations (logging, scaling and future CI/CD).