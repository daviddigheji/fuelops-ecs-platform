# FuelOps ECS Platform

Production-style AWS ECS Fargate platform for a sample application, built with Terraform to demonstrate practical cloud engineering skills across networking, load balancing, container orchestration, IAM, logging, and infrastructure as code.

## Overview

This project uses Terraform to deploy a container platform on AWS. The application runs on ECS Fargate behind an Application Load Balancer, with networking, security groups, IAM permissions, and CloudWatch logging configured as part of the infrastructure.

## Architecture Diagram

The FuelOps ECS Platform uses a production-style AWS architecture designed around security, scalability, and operational visibility.

Key architectural principles include:
- Public/private subnet separation
- Internet-facing Application Load Balancer (ALB)
- ECS Fargate workloads deployed in private subnets
- NAT Gateway for secure outbound internet access
- Centralized logging using Amazon CloudWatch
- Multi-subnet deployment for high availability

![FuelOps Architecture](docs/architecture/fuelops-production-architecture.png)

## Architecture Components

| Component | Purpose |
|---|---|
| VPC | Provides isolated AWS networking environment |
| Public Subnets | Hosts internet-facing resources like the ALB |
| Private Subnets | Hosts secure ECS workloads |
| Application Load Balancer | Distributes incoming traffic across ECS services |
| ECS Fargate | Runs containerized application workloads |
| NAT Gateway | Enables secure outbound internet access for private workloads |
| CloudWatch Logs | Centralized logging and monitoring |
| Internet Gateway | Enables internet connectivity for public resources |

## Security Design

The platform follows AWS security best practices by separating public and private networking layers.

Security considerations include:
- ECS workloads deployed in private subnets
- Public access restricted to the Application Load Balancer
- Controlled outbound internet access through NAT Gateway
- Security groups limiting inbound and outbound traffic
- IAM roles used for ECS task execution
- Centralized logging for operational visibility and monitoring

## Business Use Case

FuelOps simulates a production-style container platform for a fuel distribution operations company requiring scalable, resilient, and observable application infrastructure.

The platform demonstrates how modern organizations can deploy containerized workloads securely using AWS managed services while maintaining separation between public-facing and private application layers.

The architecture is designed to support:
- scalable web application deployment,
- secure network segmentation,
- centralized logging and monitoring,
- infrastructure automation using Terraform,
- operational consistency across environments.

## Tech Stack

- AWS ECS Fargate
- Application Load Balancer (ALB)
- Amazon VPC
- Public and Private Subnets
- NAT Gateway
- Internet Gateway
- AWS IAM
- Amazon CloudWatch Logs
- Terraform
- Docker
- GitHub
- Linux

## Quick Start

```bash
git clone git@github.com:daviddigheji/fuelops-ecs-platform.git

cd fuelops-ecs-platform/terraform/environments/prod

terraform init
terraform plan
terraform apply

## Project structure

```text
fuelops-ecs-platform/
├── README.md
├── .gitignore
├── docs/
│   ├── 00-repo-structure.png
│   ├── 01-ecs-service-running.png
│   ├── 02-cloudwatch-logs-fuelops-prod.png
│   └── 03-fuelops-ecs-prod-app-logs-2026-05-13.txt
└── terraform/
    └── environments/
        └── prod/
            ├── backend.tf
            ├── provider.tf
            ├── variables.tf
            ├── networking.tf
            ├── alb.tf
            ├── ecs.tf
            ├── outputs.tf
            └── main.tf
```

This layout keeps the infrastructure easy to read and explain. Splitting resources into `networking.tf`, `alb.tf`, and `ecs.tf` makes the design more maintainable and helps reviewers quickly understand the responsibility of each file.

## Terraform Configuration Breakdown

### `backend.tf`

Defines the Terraform backend configuration for remote state management.

### `provider.tf`

Configures the AWS provider and region used by the deployment.

### `variables.tf`

Declares reusable input variables such as project name, environment, VPC CIDR, and other configurable values.

### `networking.tf`

Contains the network layer: VPC, subnets, internet gateway, NAT gateway, route tables, and security groups.

### `alb.tf`

Defines the traffic entry layer: Application Load Balancer, target group, and HTTP listener.

### `ecs.tf`

Defines the runtime layer: ECS cluster, task execution IAM role, CloudWatch log group, task definition, and ECS service.

### `outputs.tf`

Exposes important values such as identifiers and endpoints that are useful after deployment.

### `main.tf`

Acts as the root Terraform entry point and may remain minimal when resources are separated into focused files.

## Deployment workflow

From the Terraform environment directory, the deployment flow is:

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

After deployment, the next checks are to confirm that the ECS service is healthy, the ALB is forwarding traffic, and the CloudWatch log group is receiving application logs.

To avoid unnecessary AWS charges, the environment can be removed after testing with:

```bash
terraform destroy
```

## Observability and evidence

This project includes basic observability through Amazon CloudWatch Logs for the ECS Fargate workload.

After deployment, the service was verified in the ECS console with `fuelops-prod-service` showing 1 desired task and 1 running task, confirming that the application was successfully deployed.

Application log output was then reviewed in CloudWatch Logs under the `/ecs/fuelops-prod` log group. The log stream showed timestamped HTTP `GET /` requests from the running container, confirming that the service was receiving traffic and writing logs as expected.

### Evidence files

- `docs/00-repo-structure.png` — VS Code screenshot showing the repository structure.
- `docs/01-ecs-service-running.png` — ECS service view showing the running Fargate task and successful deployment status.
- `docs/02-cloudwatch-logs-fuelops-prod.png` — CloudWatch log events from the `ecs/fuelops-prod-app/...` stream.
- `docs/03-fuelops-ecs-prod-app-logs-2026-05-13.txt` — Downloaded sample log output from CloudWatch Logs.

## Key learning points

This project demonstrates practical understanding of:

- Infrastructure as code with Terraform.
- AWS networking design for public and private workloads.
- ECS Fargate service deployment behind an ALB.
- IAM permissions for ECS task execution and log delivery.
- Operational verification using CloudWatch Logs.
- Structuring Terraform code in a modular, readable format for real-world collaboration and maintenance.

## Future improvements

Possible next improvements for this platform include:

- HTTPS listener with ACM certificate on the ALB.
- ECS service auto scaling based on CPU or memory.
- A small sample frontend or API application to make the platform more visibly end-to-end.
- Further module reuse and multi-environment expansion.

## Author

David Digheji

- Portfolio: https://daviddigheji.com
- GitHub: https://github.com/daviddigheji
- LinkedIn: https://linkedin.com/in/david-digheji
