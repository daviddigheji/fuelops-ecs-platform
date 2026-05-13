# FuelOps ECS Platform

Infrastructure-as-code project for deploying a production-style AWS ECS Fargate platform for a sample FuelOps application using Terraform. The platform is designed to demonstrate practical cloud engineering skills across networking, load balancing, container orchestration, IAM, and logging.

## Project overview

This project provisions a small but realistic AWS container platform in `eu-west-2` using Terraform. It deploys a dedicated VPC across two Availability Zones, public and private subnets, an internet-facing Application Load Balancer (ALB), an ECS cluster running Fargate tasks, and CloudWatch logging.

The goal is to model a minimum viable production-style architecture rather than a simple single-resource demo. That means the application is reachable through the ALB in public subnets, while the ECS tasks run privately and securely in private subnets.

## Target architecture (MVP)

The current target architecture includes:

- A dedicated VPC for the FuelOps environment
- Two public subnets for internet-facing components
- Two private subnets for ECS tasks
- An Internet Gateway for public connectivity
- A NAT Gateway for outbound internet access from private subnets
- Public and private route tables
- Security groups for the ALB and ECS service
- An Application Load Balancer with HTTP listener
- An IP-based target group for ECS/Fargate
- An ECS cluster running a Fargate service
- A task execution IAM role for pulling images and writing logs
- A CloudWatch Log Group for container logs

## Architecture flow

1. A user sends an HTTP request to the Application Load Balancer.
2. The ALB listener forwards the request to the target group.
3. The target group routes traffic to the ECS service running in private subnets.
4. The ECS service runs a Fargate task based on the task definition.
5. Container logs are sent to CloudWatch Logs.
6. Private workloads use the NAT Gateway for outbound internet access when required.

## Repository structure

```text
fuelops-ecs-platform/
├── app/
├── docs/
├── screenshots/
├── terraform/
│   └── environments/
│       └── prod/
│           ├── backend.tf
│           ├── provider.tf
│           ├── variables.tf
│           ├── networking.tf
│           ├── alb.tf
│           ├── ecs.tf
│           ├── outputs.tf
│           └── main.tf
├── .gitignore
└── README.md
```

## Terraform file purpose

### backend.tf
Configures the Terraform remote backend in Amazon S3 so state is stored centrally and can be managed more safely than local state.

### provider.tf
Configures the AWS provider and deployment region.

### variables.tf
Defines reusable input variables such as project name, environment, region, VPC CIDR, subnet CIDRs, and availability zones.

### networking.tf
Contains the core network infrastructure:
- VPC
- Internet Gateway
- Public and private subnets
- NAT Gateway and Elastic IP
- Route tables and associations
- ALB and ECS service security groups

### alb.tf
Contains the Application Load Balancer resources:
- ALB
- Target group
- Listener

### ecs.tf
Contains the container runtime resources:
- ECS cluster
- ECS task execution IAM role
- CloudWatch log group
- ECS task definition
- ECS service

### outputs.tf
Exposes useful values such as VPC ID, subnet IDs, gateway IDs, and the ALB DNS name.

### main.tf
Kept as the root entry-point file by convention. The main resource definitions were refactored into separate files by concern for readability and maintainability.

## Current deployment configuration

- **Region:** eu-west-2
- **Environment:** prod
- **Container image:** `nginx:alpine`
- **Launch type:** AWS Fargate
- **CPU / Memory:** 256 / 512
- **Load balancer:** Application Load Balancer
- **Target type:** IP
- **Log retention:** 7 days

## Key design decisions

### Why Fargate?
Fargate removes the need to manage EC2 worker nodes and lets the platform focus on the application task definition, networking, IAM, and service behaviour.

### Why private subnets for ECS tasks?
Running ECS tasks in private subnets improves security by preventing direct public access. The ALB handles inbound traffic, and the NAT Gateway supports outbound internet access when needed.

### Why split the Terraform files?
The project was initially built in a single `main.tf`, then refactored into `networking.tf`, `alb.tf`, and `ecs.tf` so the code is easier to read, maintain, review, and explain.

## How to use

From the production environment directory:

```bash
cd terraform/environments/prod
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

To destroy the infrastructure:

```bash
terraform destroy
```

## Sample outputs

After deployment, Terraform outputs values including:

- `vpc_id`
- `public_subnet_ids`
- `private_subnet_ids`
- `nat_gateway_id`
- `internet_gateway_id`
- `alb_dns_name`

The `alb_dns_name` output can be used to test the running application in a browser.

## Learning outcomes

This project demonstrates:

- Terraform configuration structure and refactoring
- AWS VPC design with public/private subnet separation
- ECS Fargate service deployment
- Application Load Balancer integration with ECS
- IAM execution role usage for ECS tasks
- CloudWatch logging integration
- Practical infrastructure-as-code documentation and GitHub presentation

## Future improvements

Planned next steps include:

- HTTPS listener with ACM certificate
- Route 53 DNS integration
- ECS service auto scaling
- CI/CD pipeline for Terraform and container deployments
- ECR image workflow instead of a public container image
- Reusable Terraform modules for multi-environment deployments