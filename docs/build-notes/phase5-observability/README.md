# Phase 5: Observability

## Objective

This phase documents the observability layer of the FuelOps ECS Platform.

The goal was to ensure that the containerised application running on ECS Fargate can produce logs that are captured centrally in AWS CloudWatch for monitoring, troubleshooting, and operational visibility.

## What Was Implemented

- CloudWatch Log Group for ECS application logs
- ECS task definition configured with AWS Logs driver
- Application logs forwarded from ECS Fargate tasks to CloudWatch
- Evidence captured showing running ECS service and log output
- Basic operational visibility for container health and application behaviour

## Why This Matters

In production environments, deploying an application is not enough. Engineers must be able to see what the application is doing, detect failures, troubleshoot issues, and understand system behaviour.

CloudWatch logging provides a central place to review container logs without connecting directly to infrastructure.

## AWS Services Used

- Amazon ECS Fargate
- Amazon CloudWatch Logs
- IAM
- Terraform

## Evidence Captured

Evidence for this phase is stored in:

```text
docs/evidence/