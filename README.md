# FuelOps ECS Platform

Production-style AWS ECS Fargate platform for a sample application, built with Terraform to demonstrate practical cloud engineering skills across networking, load balancing, container orchestration, IAM, logging, and infrastructure as code.

## Overview

This project uses Terraform to deploy a container platform on AWS. The application runs on ECS Fargate behind an Application Load Balancer, with networking, security groups, IAM permissions, and CloudWatch logging configured as part of the infrastructure.

## Architecture

The platform includes the following core components:

- Amazon VPC for network isolation, with public and private subnets across Availability Zones.
- Internet Gateway and NAT Gateway for controlled inbound and outbound connectivity.
- Application Load Balancer in the public subnets to receive inbound HTTP traffic.
- ECS cluster and ECS Fargate service running the application in private subnets.
- Security groups separating ALB access from ECS task access.
- IAM task execution role for pulling images and sending logs.
- CloudWatch Logs for application log collection and operational verification.

## Target architecture

The target architecture for this MVP is a secure and modular ECS Fargate deployment pattern suitable for portfolio demonstration and interview discussion. The ALB is internet-facing in the public subnets, while the application tasks run in private subnets to reduce direct exposure and follow common AWS design practice. Traffic flows from the ALB to the ECS service through a target group using IP targets, which is the standard pattern for Fargate networking.

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

## Terraform files

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
