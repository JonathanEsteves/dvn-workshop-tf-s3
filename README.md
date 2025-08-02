# 🏗️ Terraform Remote Backend Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-v1.0+-623CE4?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=flat&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![S3](https://img.shields.io/badge/AWS-S3-569A31?style=flat&logo=amazon-s3&logoColor=white)](https://aws.amazon.com/s3/)
[![DynamoDB](https://img.shields.io/badge/AWS-DynamoDB-4053D6?style=flat&logo=amazon-dynamodb&logoColor=white)](https://aws.amazon.com/dynamodb/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **DevOps na Nuvem Workshop** - Bootstrap infrastructure for Terraform remote state management using AWS S3 and DynamoDB state locking.

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Configuration](#-configuration)
- [Infrastructure Components](#-infrastructure-components)
- [Usage](#-usage)
- [State Management](#-state-management)
- [Security Considerations](#-security-considerations)
- [Troubleshooting](#-troubleshooting)
- [Related Projects](#-related-projects)
- [Contributing](#-contributing)

## 🎯 Overview

This repository contains the **foundational infrastructure** for the DevOps na Nuvem Workshop. It provisions the essential AWS resources needed for Terraform remote state management, including an S3 bucket for state storage and a DynamoDB table for state locking.

### Why This Matters

Before deploying complex infrastructure with Terraform, you need a reliable way to:
- 🔒 **Store state remotely** for team collaboration
- 🚫 **Prevent concurrent modifications** with state locking
- 📦 **Version your infrastructure state** for rollback capabilities
- 🛡️ **Secure your state files** with proper access controls

This project solves the "chicken and egg" problem of needing infrastructure to manage infrastructure state.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     AWS Account                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                    S3 Bucket                        │    │
│  │  workshop-s3-remote-backend-bucket-     │    │
│  │                                                     │    │
│  │  ├── networking-stack/                              │    │
│  │  │   └── terraform.tfstate                          │    │
│  │  ├── compute-stack/                                 │    │
│  │  │   └── terraform.tfstate                          │    │
│  │  └── database-stack/                                │    │
│  │      └── terraform.tfstate                          │    │
│  │                                                     │    │
│  │  Features:                                          │    │
│  │  • Versioning Enabled                               │    │
│  │  • Server-side Encryption                           │    │
│  │  • Access Logging                                   │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                DynamoDB Table                       │    │
│  │         workshop-s3-state-locking-table             │    │
│  │                                                     │    │
│  │  Hash Key: LockID (String)                          │    │
│  │  Billing Mode: PAY_PER_REQUEST                      │    │
│  │                                                     │    │
│  │  Purpose:                                           │    │
│  │  • Prevent concurrent Terraform runs               │    │
│  │  • Ensure state consistency                         │    │
│  │  • Automatic cleanup of stale locks                │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## ✨ Features

- 🗄️ **S3 Remote State Storage**: Centralized, durable state management
- 🔐 **DynamoDB State Locking**: Prevents concurrent modifications and state corruption
- 📝 **Versioning Enabled**: Track changes and enable rollbacks
- 🏷️ **Consistent Tagging**: Organized resource management and cost tracking
- 🔧 **Pay-per-Request Billing**: Cost-effective DynamoDB pricing model
- 🛡️ **IAM Role Integration**: Secure authentication using AWS IAM roles
- 📦 **Modular Design**: Clean separation of concerns for easy maintenance

## 📋 Prerequisites

Before you begin, ensure you have the following:

### Required Tools
- **Terraform** >= 1.0
- **AWS CLI** >= 2.0
- **Git**

### AWS Requirements
- Valid AWS credentials configured
- IAM permissions for:
  - S3 bucket creation and management
  - DynamoDB table creation and management
  - IAM role assumption (if using roles)

### Recommended Setup
```bash
# Verify AWS credentials
aws sts get-caller-identity

# Check Terraform version
terraform version

# Verify AWS CLI version
aws --version
```

## 🚀 Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/JonathanEsteves/dvn-workshop-tf-s3.git
cd dvn-workshop-tf-s3

# Ensure you're on the main branch
git checkout main
```

### 2. Review Configuration

```bash
# Review the variables
cat variables.tf

# Check the main configuration
cat main.tf
```

### 3. Deploy the Backend Infrastructure

```bash
# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply
```

### 4. Verify Deployment

```bash
# Check the outputs
terraform output

# Verify S3 bucket creation
aws s3 ls | grep workshop-s3-remote-backend

# Verify DynamoDB table creation
aws dynamodb list-tables | grep workshop-s3-state-locking
```

## ⚙️ Configuration

### Default Configuration

The project comes with sensible defaults for the DevOps na Nuvem Workshop:

```hcl
# S3 Bucket for state storage
s3_bucket = "workshop-s3-remote-backend-bucket"

# DynamoDB table for state locking
dynamodb_table_name = "workshop-s3-state-locking-table"
billing_mode = "PAY_PER_REQUEST"
hash_key = "LockID"

# AWS Configuration
region = "us-west-1"
assume_role_arn = ""
```

### Customization

To adapt this for your own use:

1. **Update the S3 bucket name** in `variables.tf`:
   ```hcl
   s3_bucket = "your-unique-bucket-name-${random_id}"
   ```

2. **Modify the AWS region** if needed:
   ```hcl
   region = "your-preferred-region"
   ```

3. **Update IAM role ARN** for your account:
   ```hcl
   assume_role_arn = "arn:aws:iam::YOUR-ACCOUNT:role/YOUR-ROLE"
   ```

4. **Customize resource tags**:
   ```hcl
   tags = {
     Project     = "your-project-name"
     Environment = "your-environment"
     Owner       = "your-team"
   }
   ```

## 🏗️ Infrastructure Components

### S3 Bucket (`s3.bucket.tf`)

| Feature | Configuration | Purpose |
|---------|---------------|---------|
| **Bucket Name** | `workshop-s3-remote-backend-bucket` | Unique identifier for state storage |
| **Versioning** | Enabled | Track state file changes and enable rollbacks |
| **Encryption** | Server-side (default) | Protect state files at rest |
| **Access Control** | IAM-based | Secure access to state files |

### DynamoDB Table (`dynamo.table.tf`)

| Feature | Configuration | Purpose |
|---------|---------------|---------|
| **Table Name** | `workshop-s3-state-locking-table` | State lock coordination |
| **Hash Key** | `LockID` (String) | Unique identifier for locks |
| **Billing Mode** | `PAY_PER_REQUEST` | Cost-effective for variable workloads |
| **Attributes** | Minimal schema | Optimized for lock operations |

## 💻 Usage

### Initial Deployment

This is typically a **one-time setup** per AWS account/region:

```bash
# Deploy the backend infrastructure
terraform init
terraform plan
terraform apply

# Note the outputs for future use
terraform output -json > backend-config.json
```

### Using the Remote Backend

After deployment, other Terraform projects can use this backend:

```hcl
terraform {
  backend "s3" {
    bucket         = "workshop-s3-remote-backend-bucke"
    remote-backend-bucket-/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "workshop-s3-state-locking-table"
    encrypt        = true
  }
}
```

### Common Operations

```bash
# Check backend status
terraform state list

# View remote state
terraform state pull

# Force unlock (if needed)
terraform force-unlock LOCK_ID

# Backup current state
terraform state pull > backup-$(date +%Y%m%d).tfstate
```

## 🔄 State Management

### How It Works

1. **State Storage**: Terraform state files are stored in the S3 bucket
2. **State Locking**: DynamoDB prevents concurrent modifications
3. **Versioning**: S3 versioning tracks all state changes
4. **Encryption**: State files are encrypted at rest

### Best Practices

- ✅ **Never edit state files manually**
- ✅ **Always use `terraform state` commands for state operations**
- ✅ **Regularly backup your state files**
- ✅ **Monitor DynamoDB for stuck locks**
- ✅ **Use separate state files for different environments**

### State File Organization

```
s3://workshop-s3-remote-backend-bucket-471112511203/
├── networking-stack/
│   └── terraform.tfstate
├── compute-stack/
│   └── terraform.tfstate
├── database-stack/
│   └── terraform.tfstate
└── monitoring-stack/
    └── terraform.tfstate
```

## 🛡️ Security Considerations

### Access Control

- **IAM Roles**: Use IAM roles instead of access keys
- **Least Privilege**: Grant minimal required permissions
- **MFA**: Enable MFA for sensitive operations
- **Audit Logging**: Enable CloudTrail for API calls

### State File Security

- **Encryption**: State files contain sensitive data and are encrypted
- **Access Logs**: S3 access logging tracks who accesses state files
- **Versioning**: Protects against accidental deletions or corruption
- **Backup Strategy**: Regular backups to separate storage

### Recommended IAM Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::workshop-s3-remote-backend-bucket-471112511203",
        "arn:aws:s3:::workshop-s3-remote-backend-bucket-471112511203/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:us-west-1:471112511203:table/workshop-s3-state-locking-table"
    }
  ]
}
```

## 🔧 Troubleshooting

### Common Issues

**Issue**: S3 bucket already exists
```bash
# Solution: Choose a different bucket name or check if you own it
aws s3api head-bucket --bucket workshop-s3-remote-backend-bucket-471112511203
```

**Issue**: DynamoDB table creation fails
```bash
# Solution: Check for existing table or permissions
aws dynamodb describe-table --table-name workshop-s3-state-locking-table
```

**Issue**: State lock timeout
```bash
# Solution: Check for stuck locks and force unlock if necessary
aws dynamodb scan --table-name workshop-s3-state-locking-table
terraform force-unlock LOCK_ID
```

**Issue**: Permission denied errors
```bash
# Solution: Verify IAM permissions and role assumption
aws sts get-caller-identity
aws iam get-role --role-name dvn-workshop-role
```

### Debug Commands

```bash
# Enable debug logging
export TF_LOG=DEBUG

# Check AWS credentials
aws sts get-caller-identity

# Verify S3 access
aws s3 ls s3://workshop-s3-remote-backend-bucket-471112511203

# Check DynamoDB table
aws dynamodb describe-table --table-name workshop-s3-state-locking-table
```

## 🔗 Related Projects

This backend infrastructure supports the following workshop components:

- **[Networking Stack](https://github.com/JonathanEsteves/dvn-workshop-tf-s3/tree/networking-vpc)** - VPC, subnets, and networking components
- **Compute Stack** - EC2 instances, Auto Scaling Groups, Load Balancers
- **Database Stack** - RDS, ElastiCache, and data storage solutions
- **Monitoring Stack** - CloudWatch, logging, and observability tools

### Integration Example

```hcl
# In other Terraform projects
terraform {
  backend "s3" {
    bucket         = "workshop-s3-remote-backend-bucket-471112511203"
    key            = "networking-stack/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "workshop-s3-state-locking-table"
    encrypt        = true
  }
}
```

## 🤝 Contributing

Contributions are welcome! This project follows the DevOps na Nuvem Workshop standards.

### Development Workflow

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Test** your changes thoroughly
4. **Commit** your changes (`git commit -m 'Add amazing feature'`)
5. **Push** to the branch (`git push origin feature/amazing-feature`)
6. **Open** a Pull Request

### Guidelines

- Follow Terraform best practices and style guide
- Update documentation for any configuration changes
- Test with multiple AWS regions if applicable
- Ensure backward compatibility
- Add appropriate tags and comments

### Testing

```bash
# Validate Terraform configuration
terraform validate

# Format code
terraform fmt -check

# Security scanning (if available)
tfsec .

# Plan without applying
terraform plan -out=tfplan
```

## 📊 Cost Considerations

### S3 Costs
- **Storage**: Minimal cost for state files (typically < 1MB each)
- **Requests**: GET/PUT requests for state operations
- **Versioning**: Additional storage for state file versions

### DynamoDB Costs
- **Pay-per-Request**: Only charged for actual lock operations
- **Typical Usage**: Very low cost (< $1/month for most projects)
- **No Minimum**: No base charges or minimum capacity

### Cost Optimization Tips
- 🔄 **Enable S3 lifecycle policies** for old state versions
- 📊 **Monitor usage** with AWS Cost Explorer
- 🗑️ **Clean up unused state files** periodically
- 📈 **Use AWS Budgets** to track costs

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **DevOps na Nuvem Workshop** community and participants
- **HashiCorp Terraform** team for excellent tooling
- **AWS** for reliable cloud infrastructure
- **Open Source Community** for best practices and examples

---

<div align="center">

**🚀 Bootstrap Your Terraform Journey with Confidence**

[⭐ Star this repo](https://github.com/JonathanEsteves/dvn-workshop-tf-s3) | [🐛 Report Bug](https://github.com/JonathanEsteves/dvn-workshop-tf-s3/issues) | [💡 Request Feature](https://github.com/JonathanEsteves/dvn-workshop-tf-s3/issues) | [📚 Workshop Docs](https://github.com/JonathanEsteves/dvn-workshop-tf-s3/wiki)

**Built with ❤️ for the DevOps na Nuvem Workshop**

</div>
