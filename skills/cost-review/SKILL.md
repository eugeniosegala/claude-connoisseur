---
name: cost-review
description: Estimate monthly cloud costs from infrastructure and application files.
argument-hint: "[files] [instructions]"
user-invocable: true
disable-model-invocation: true
context: fork
agent: Explore
---

# Cost Review

Analyse the project's infrastructure and application configuration to produce a monthly cost estimate with optimisation suggestions.

Files and instructions: $ARGUMENTS

## What to review

- **Compute**: VMs, containers, serverless functions, App Service plans, ECS/EKS tasks — instance types, vCPUs, memory, expected runtime hours
- **Database**: RDS, Aurora, DynamoDB, Cloud SQL, Cosmos DB, ElastiCache — instance class, storage, IOPS, read/write capacity, replicas
- **Storage**: S3, GCS, Azure Blob, EBS/EFS — storage class, expected volume, request rates, lifecycle policies
- **Networking**: NAT gateways, load balancers, data transfer (inter-region, internet egress), VPC endpoints, CDN
- **Serverless**: Lambda, Cloud Functions, Azure Functions — memory allocation, expected invocations, duration, provisioned concurrency
- **Messaging & queues**: SQS, SNS, EventBridge, Pub/Sub, Service Bus — message volume, retention, delivery retries
- **Monitoring & logging**: CloudWatch, Datadog, log ingestion/storage, custom metrics, alarms
- **CI/CD & build**: build minutes, artefact storage, container registry
- **Third-party services**: APIs with usage-based pricing, SaaS integrations, DNS, domain registration, SSL certificates
- **Application-level costs**: paid API calls found in code (AI/ML model APIs, payment gateways, geocoding, email/SMS providers like SendGrid, Twilio), HTTP requests to metered endpoints, SDK usage for pay-per-use services, webhook delivery volume
- **Hidden costs**: cross-AZ data transfer, DNS query volume, KMS key operations, Secrets Manager API calls, IP address charges

## Where to look

Scan the project for infrastructure files, configuration, and application code. Common sources include:

- **Terraform**: `*.tf`, `*.tfvars` — resource definitions, instance types, storage configs
- **CloudFormation / SAM**: `template.yaml`, `template.json`
- **CDK**: `lib/*.ts`, `lib/*.py` — infrastructure as code
- **Pulumi**: `Pulumi.yaml`, `index.ts`, `__main__.py`
- **Kubernetes**: `*.yaml` in `k8s/`, `manifests/`, `charts/` — resource requests/limits, replica counts, PVCs
- **Docker Compose**: `docker-compose.yml` — service definitions, resource constraints
- **Serverless Framework**: `serverless.yml` — function configs, memory, timeout
- **Application config**: environment variables, connection strings, queue URLs — hints at services in use
- **Application code**: HTTP client calls, SDK imports (`@anthropic-ai/sdk`, `stripe`, `twilio`, `@sendgrid/mail`, `boto3`, etc.), API key references, webhook handlers — indicators of pay-per-use services
- **Dependency manifests**: `package.json`, `requirements.txt`, `go.mod`, `Gemfile` — paid SDK dependencies hint at service usage
- **CI/CD pipelines**: `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile` — build resources, runner types

If no infrastructure files are found, infer from the application code what services would be required to run it (e.g. a Django app implies a web server, database, and likely object storage).

## How to interpret arguments

The arguments are free-form and flexible. They may contain:

- File references of any type and in any format: `@main.tf`, `serverless.yml, docker-compose.yml`, `template.yaml k8s/deployment.yaml`
- Additional natural language instructions alongside file references, such as:
  - "assume 10k daily active users"
  - "we're on AWS eu-west-1"
  - "this will run on ECS Fargate"
  - "we expect 1M Lambda invocations per month"

Parse the arguments to identify which files to analyse and what additional assumptions apply. When no files are provided, explore the project to find relevant infrastructure and application files.

### Examples

- `/cost-review` — scan the entire project and estimate costs
- `/cost-review @main.tf @variables.tf` — estimate from specific Terraform files
- `/cost-review assume 10k daily active users on AWS eu-west-1` — estimate with usage assumptions
- `/cost-review @serverless.yml we expect 1M invocations per month` — estimate with traffic context
- `/cost-review @docker-compose.yml this will run on ECS Fargate` — estimate with deployment target

## How to proceed

1. If the user provided specific files, start there. Otherwise, explore the project to find infrastructure and configuration files
2. If the user included additional instructions (e.g. "assume 10k daily users", "we're on AWS eu-west-1"), factor them into the estimate
3. For each service identified, estimate:
   - **Service**: what it is and the specific SKU/tier
   - **Configuration**: instance type, storage, capacity, replicas
   - **Assumptions**: traffic, usage patterns, hours of operation — state these clearly
   - **Monthly cost**: estimated range (low–high) in USD based on public pricing
4. Present a summary table with per-service costs and a total range
5. Flag the top 3 cost optimisation opportunities, such as:
   - Right-sizing over-provisioned resources
   - Reserved instances or savings plans vs on-demand
   - Switching storage classes or enabling lifecycle rules
   - Eliminating unused resources
   - Reducing data transfer costs
6. Note any costs that could not be estimated and what information is missing
7. State the cloud provider pricing page used as reference and the date of the estimate

## Output format

```
## Cost Estimate Summary

| Service         | Configuration        | Assumptions           | Monthly Cost (USD) |
|-----------------|---------------------|-----------------------|--------------------|
| EC2             | t3.medium x2        | 24/7, eu-west-1       | $60–$70            |
| RDS PostgreSQL  | db.t3.medium, 100GB | Single-AZ, 500 IOPS  | $45–$55            |
| ...             | ...                 | ...                   | ...                |
| **Total**       |                     |                       | **$XXX–$YYY**      |

## Top optimisation opportunities
1. ...
2. ...
3. ...

## Unknowns
- ...
```
