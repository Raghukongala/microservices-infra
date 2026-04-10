# microservices-infra

Terraform infrastructure for deploying a microservices EKS cluster on AWS (ap-south-1).

## Project Structure

```
microservices-infra/
├── Jenkinsfile
├── .gitignore
└── terraform/
    ├── envs/
    │   └── dev/
    │       ├── backend.tf       # S3 remote state + DynamoDB lock
    │       ├── providers.tf     # AWS provider config
    │       ├── variables.tf     # All input variables
    │       ├── main.tf          # Module calls
    │       └── outputs.tf       # Cluster/ECR outputs
    └── modules/
        ├── vpc/                 # VPC, subnets, IGW, route tables
        ├── ecr/                 # ECR repos + lifecycle policies
        └── eks/                 # EKS cluster via terraform-aws-eks v21
```

## Prerequisites

- AWS CLI configured with sufficient IAM permissions
- Terraform >= 1.5.0
- S3 bucket `raghu-buk` created in `ap-south-1`
- DynamoDB table `terraform-state-lock` created (for state locking)
- Jenkins with AWS credentials configured

## DynamoDB Table (one-time setup)

```bash
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1
```

## Manual Usage

```bash
cd terraform/envs/dev
terraform init
terraform plan
terraform apply
```

## Modules

| Module | Description |
|--------|-------------|
| `vpc`  | VPC with public subnets, IGW, route tables, EKS subnet tags |
| `ecr`  | ECR repos for user-service, product-service, order-service, api-gateway |
| `eks`  | EKS cluster (v21 module), managed node groups, addons, IRSA |

## ECR Repositories

- `user-service`
- `product-service`
- `order-service`
- `api-gateway`
