# 🚀 AWS Networking Infrastructure with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-v1.0+-623CE4?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=flat&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **DevOps na Nuvem Workshop** - Complete AWS networking infrastructure provisioning using Terraform with S3 remote state management and DynamoDB state locking.

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Configuration](#-configuration)
- [Infrastructure Components](#-infrastructure-components)
- [Usage](#-usage)
- [Outputs](#-outputs)
- [Best Practices](#-best-practices)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)

## 🎯 Overview

This repository contains a production-ready Terraform configuration for provisioning a complete AWS networking infrastructure. It's designed as part of the **DevOps na Nuvem Workshop** and demonstrates best practices for infrastructure as code, including remote state management and proper resource organization.

### What's Included

- **VPC with public and private subnets** across multiple availability zones
- **Internet Gateway** for public internet access
- **NAT Gateway** for secure outbound internet access from private subnets
- **Route tables** with proper routing configuration
- **S3 backend** for remote state storage
- **DynamoDB table** for state locking
- **Elastic IP** for NAT Gateway

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        AWS VPC (10.0.0.0/24)               │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐              ┌─────────────────┐       │
│  │  Public Subnet  │              │  Public Subnet  │       │
│  │   us-west-1a    │              │   us-west-1c    │       │
│  │ 10.0.0.0/26     │              │ 10.0.0.64/26    │       │
│  └─────────────────┘              └─────────────────┘       │
│           │                                 │               │
│  ┌─────────────────┐              ┌─────────────────┐       │
│  │ Private Subnet  │              │ Private Subnet  │       │
│  │   us-west-1a    │              │   us-west-1c    │       │
│  │ 10.0.0.128/26   │              │ 10.0.0.192/26   │       │
│  └─────────────────┘              └─────────────────┘       │
└─────────────────────────────────────────────────────────────┘
           │                                 │
    ┌──────────────┐                ┌──────────────┐
    │ NAT Gateway  │                │Internet Gateway│
    └──────────────┘                └──────────────┘
```

## ✨ Features

- 🌐 **Multi-AZ Deployment**: Resources distributed across multiple availability zones for high availability
- 🔒 **Secure Architecture**: Private subnets with NAT Gateway for secure outbound connectivity
- 📦 **Remote State Management**: S3 backend with DynamoDB locking for team collaboration
- 🏷️ **Consistent Tagging**: Automated resource tagging for better organization and cost tracking
- 🔧 **Modular Design**: Well-organized Terraform files for easy maintenance and scalability
- 🛡️ **IAM Role Integration**: Secure AWS authentication using IAM roles

## 📋 Prerequisites

Before you begin, ensure you have the following installed and configured:

- **Terraform** >= 1.0
- **AWS CLI** >= 2.0
- **Git**
- Valid AWS credentials with appropriate permissions

### Required AWS Permissions

Your AWS credentials need the following permissions:
- VPC and subnet management
- Internet Gateway and NAT Gateway management
- Route table management
- Elastic IP management
- S3 bucket access
- DynamoDB table access

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/JonathanEsteves/dvn-workshop-tf-s3.git
   cd dvn-workshop-tf-s3
   git checkout networking-vpc
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the plan**
   ```bash
   terraform plan
   ```

4. **Apply the configuration**
   ```bash
   terraform apply
   ```

5. **Verify the deployment**
   ```bash
   terraform output
   ```

## ⚙️ Configuration

### Backend Configuration

The project uses S3 for remote state storage with DynamoDB for state locking:

```hcl
backend "s3" {
  bucket       = "workshop-s3-remote-backend-bucket-471112511203"
  key          = "networking-stack/terraform.tfstate"
  region       = "us-west-1"
  use_lockfile = true
}
```

### Variables

Key configuration variables can be customized in `variables.tf`:

| Variable | Description | Default |
|----------|-------------|---------|
| `vpc.cidr_block` | VPC CIDR block | `10.0.0.0/24` |
| `auth.region` | AWS region | `us-west-1` |
| `auth.assume_role_arn` | IAM role ARN | Workshop-specific role |

### Customization

To customize the infrastructure for your needs:

1. **Modify CIDR blocks** in `variables.tf`
2. **Update availability zones** based on your target region
3. **Adjust resource names** and tags
4. **Configure your own S3 bucket** for state storage

## 🏗️ Infrastructure Components

### Core Networking

| Component | File | Description |
|-----------|------|-------------|
| VPC | `vpc.tf` | Main virtual private cloud |
| Public Subnets | `vpc.public-subnets.tf` | Internet-accessible subnets |
| Private Subnets | `vpc.private-subnets.tf` | Internal subnets |
| Internet Gateway | `vpc.internet-gateway.tf` | Public internet access |
| NAT Gateway | `vpc.nat-gateway.tf` | Outbound internet for private subnets |
| Route Tables | `vpc.*-route-table.tf` | Network routing configuration |

### State Management

| Component | File | Description |
|-----------|------|-------------|
| S3 Bucket | `s3.bucket.tf` | Remote state storage |
| DynamoDB Table | `dynamo.table.tf` | State locking mechanism |
| Elastic IP | `ec2.eip.tf` | Static IP for NAT Gateway |

## 💻 Usage

### Common Commands

```bash
# Initialize and download providers
terraform init

# Format code
terraform fmt

# Validate configuration
terraform validate

# Plan changes
terraform plan

# Apply changes
terraform apply

# Show current state
terraform show

# List resources
terraform state list

# Destroy infrastructure (use with caution!)
terraform destroy
```

### Working with Remote State

The configuration automatically uses remote state. To work with the state:

```bash
# View remote state
terraform state pull

# Import existing resources
terraform import aws_vpc.example vpc-12345678

# Move resources in state
terraform state mv aws_instance.example aws_instance.new_name
```

## 📤 Outputs

After successful deployment, the following outputs are available:

```bash
terraform output
```

| Output | Description |
|--------|-------------|
| `internet_gateway_id` | Internet Gateway ID |
| `cidr_block` | VPC CIDR block |
| `nat_gateway_id` | NAT Gateway ID |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |

## 🎯 Best Practices

This project follows Terraform and AWS best practices:

### Code Organization
- ✅ Separate files for different resource types
- ✅ Consistent naming conventions
- ✅ Proper variable definitions with types and defaults
- ✅ Comprehensive output definitions

### Security
- ✅ Private subnets for sensitive resources
- ✅ NAT Gateway for secure outbound connectivity
- ✅ IAM role-based authentication
- ✅ No hardcoded credentials

### State Management
- ✅ Remote state storage in S3
- ✅ State locking with DynamoDB
- ✅ Versioned state files
- ✅ Encrypted state storage

### Resource Management
- ✅ Consistent resource tagging
- ✅ Proper resource dependencies
- ✅ Multi-AZ deployment for high availability

## 🔧 Troubleshooting

### Common Issues

**Issue**: `terraform init` fails with backend configuration error
```bash
# Solution: Ensure S3 bucket exists and you have proper permissions
aws s3 ls s3://workshop-s3-remote-backend-bucket-471112511203
```

**Issue**: State lock error
```bash
# Solution: Check DynamoDB table and clear stuck locks if necessary
aws dynamodb scan --table-name workshop-s3-state-locking-table
```

**Issue**: Permission denied errors
```bash
# Solution: Verify your AWS credentials and IAM permissions
aws sts get-caller-identity
```

### Debug Mode

Enable Terraform debug logging:
```bash
export TF_LOG=DEBUG
terraform plan
```

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Terraform best practices
- Update documentation for any changes
- Test your changes thoroughly
- Use conventional commit messages

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **DevOps na Nuvem Workshop** community
- AWS documentation and best practices
- Terraform community and documentation

---

<div align="center">

**Built with ❤️ for the DevOps na Nuvem Workshop**

[⭐ Star this repo](https://github.com/JonathanEsteves/dvn-workshop-tf-s3) | [🐛 Report Bug](https://github.com/JonathanEsteves/dvn-workshop-tf-s3/issues) | [💡 Request Feature](https://github.com/JonathanEsteves/dvn-workshop-tf-s3/issues)

</div>
