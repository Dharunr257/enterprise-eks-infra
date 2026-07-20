# Enterprise EKS Infrastructure (Terraform)

[![Terraform Version](https://img.shields.io/badge/Terraform-%3E%3D1.0-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-%3E%3D5.0-FF9900?logo=amazon-aws&logoColor=white)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![Kubernetes Version](https://img.shields.io/badge/Kubernetes-1.33-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io/)

A modular, production-ready Infrastructure-as-Code (IaC) repository built using **Terraform** to provision **Amazon EKS (Elastic Kubernetes Service)** on AWS. This repository serves as the underlying foundational infrastructure layer for an Enterprise GitOps Platform.

---

## 📐 Architecture Overview

```
                          ┌─────────────────────────────────────────┐
                          │                AWS VPC                  │
                          │              10.0.0.0/16                │
                          │                                         │
                          │   ┌─────────────────────────────────┐   │
                          │   │   Public Subnets (us-east-1a/b) │   │
                          │   │  ┌───────────────────────────┐  │   │
                          │   │  │    EKS Worker Node Group   │  │   │
                          │   │  │      (t3.small nodes)      │  │   │
                          │   │  └─────────────┬─────────────┘  │   │
                          │   └────────────────┼────────────────┘   │
                          │                    │                    │
                          │   ┌────────────────┴────────────────┐   │
                          │   │  Private Subnets (us-east-1a/b) │   │
                          │   │  (Ready for workload workloads) │   │
                          │   └─────────────────────────────────┘   │
                          └────────────────────┬────────────────────┘
                                               │
                                 ┌─────────────┴─────────────┐
                                 │    EKS Control Plane      │
                                 │     (AWS Managed v1.33)   │
                                 └───────────────────────────┘
```

---

## ✨ Key Features

- **🧱 Reusable Terraform Modules**: Standardized, isolated modules for VPC networking, IAM, Security Groups, and EKS.
- **🔒 Remote State & Locking**: Standalone bootstrap module provisioning S3 bucket (with versioning, server-side AES256 encryption, and blocked public access) and DynamoDB state lock table.
- **🌍 Multi-Environment Support**: Clean separation of environments (`environments/dev`, `environments/prod`).
- **🛡️ Least Privilege IAM Roles**: Granular roles for EKS Control Plane, Worker Nodes, and Pod Identity service accounts.
- **💾 EKS Pod Identity Integration**: Modern EKS Pod Identity association for the AWS EBS CSI Driver addon (`aws-ebs-csi-driver`).
- **🌐 Network Infrastructure Tagging**: Automated tagging (`kubernetes.io/role/elb` & `kubernetes.io/role/internal-elb`) for Kubernetes LoadBalancer integration.
- **💰 Cost-Optimized Defaults**: Configured for portfolio/dev usage with configurable instance types and scaling bounds.

---

## 📁 Repository Structure

```directory
enterprise-eks-infra/
├── bootstrap/                    # Remote State Backend Provisioning
│   ├── main.tf                   # S3 Bucket & DynamoDB Lock Table
│   ├── backend.tf                # Local backend for initial state creation
│   ├── provider.tf               # AWS Provider configuration
│   ├── variables.tf              # Backend configuration variables
│   └── outputs.tf                # Backend bucket & table outputs
├── environments/                 # Environment Deployments
│   ├── dev/                      # Development Environment
│   │   ├── main.tf               # Module orchestration
│   │   ├── backend.tf            # Remote S3 backend configuration
│   │   ├── provider.tf           # AWS Provider settings
│   │   ├── terraform.tfvars      # Environment specific variable values
│   │   ├── variables.tf          # Input definitions
│   │   └── outputs.tf            # Deployment outputs (kubeconfig, cluster ID)
│   └── prod/                     # Production Environment (Template)
└── modules/                      # Reusable Infrastructure Modules
    ├── eks/                      # Amazon EKS Cluster & Managed Node Groups
    │   ├── cluster.tf            # EKS Control Plane definition & access configs
    │   ├── node_group.tf         # Managed Node Group configuration
    │   ├── addons.tf             # EBS CSI Driver Addon & Pod Identity
    │   ├── variables.tf          # Module inputs
    │   └── outputs.tf            # Cluster endpoint, ARNs, names
    ├── vpc/                      # Networking Module
    │   ├── vpc.tf                # AWS VPC resource
    │   ├── subnets.tf            # Public & Private subnets + tags
    │   ├── igw.tf                # Internet Gateway
    │   ├── route_tables.tf       # Public & Private route tables
    │   ├── variables.tf          # Network CIDRs & AZ inputs
    │   └── outputs.tf            # VPC ID & Subnet IDs
    ├── iam/                      # IAM Roles & Policy Attachments
    │   ├── iam_roles.tf          # EKS Cluster, Worker Node, & EBS CSI Roles
    │   ├── policy_attachments.tf# Managed policy attachments & trust policies
    │   ├── variables.tf          # Naming inputs
    │   └── outputs.tf            # IAM Role ARNs
    └── security-group/           # Network Firewall Configuration
        ├── security_groups.tf    # Cluster & Worker Security Groups & Rules
        ├── variables.tf          # SG Module inputs
        └── outputs.tf            # Security Group IDs
```

---

## 📦 Infrastructure Modules

### 1. **`vpc` Module**
Provisions the networking backbone:
- Custom VPC with CIDR `10.0.0.0/16`.
- Public & Private Subnets across configured Availability Zones (e.g., `us-east-1a`, `us-east-1b`).
- Internet Gateway and Routing Tables.
- Kubernetes ELB auto-discovery tags.

### 2. **`iam` Module**
Provisions security credentials and execution roles:
- **EKS Cluster Role**: `AmazonEKSClusterPolicy` attachment for cluster management.
- **Node Role**: `AmazonEKSWorkerNodePolicy`, `AmazonEKS_CNI_Policy`, and `AmazonEC2ContainerRegistryReadOnly`.
- **EBS CSI Role**: IAM Role configured with `pods.eks.amazonaws.com` trust policy for Pod Identity.

### 3. **`security-group` Module**
Configures stateful network firewalls:
- EKS Control Plane Security Group.
- EKS Worker Node Security Group.
- Fine-grained rules allowing Control Plane ↔ Node traffic and intra-node communication.

### 4. **`eks` Module**
Provisions the Kubernetes engine:
- Amazon EKS Cluster (Kubernetes v1.33).
- Managed Node Group with auto-scaling (`min_size: 2`, `desired_size: 3`, `max_size: 4`).
- Support for On-Demand and Spot instances.
- AWS EBS CSI Driver Add-on with Pod Identity Association.

---

## 🛠️ Prerequisites

Before deploying this infrastructure, ensure you have the following tools installed and configured:

1. **[Terraform](https://developer.hashicorp.com/terraform/downloads)** `>= 1.0`
2. **[AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)**
3. **[kubectl](https://kubernetes.io/docs/tasks/tools/)** matching your EKS version (v1.33)
4. Active **AWS Account Credentials** configured (`aws configure` or environment variables)

---

## 🚀 Getting Started & Deployment Guide

### Step 1: Initialize S3 Remote Backend & Lock Table

Navigate to the `bootstrap` directory to provision the S3 Bucket and DynamoDB Table for remote state management:

```bash
cd bootstrap
terraform init
terraform apply
```

*(Note down the S3 bucket name and DynamoDB table name from the output.)*

---

### Step 2: Deploy Environment Infrastructure (`dev`)

Navigate to the `dev` environment directory:

```bash
cd ../environments/dev
```

Initialize Terraform (this configures the S3 remote backend):

```bash
terraform init
```

Review the execution plan:

```bash
terraform plan
```

Apply the configuration to create the infrastructure:

```bash
terraform apply
```

---

### Step 3: Configure `kubectl` Access

Once `terraform apply` finishes successfully, update your local `kubeconfig` to connect to the new EKS cluster:

```bash
aws eks update-kubeconfig --region us-east-1 --name enterprise-gitops-dev
```

Verify your cluster connectivity:

```bash
kubectl get nodes
kubectl get pods -A
```

---

## ⚙️ Configuration Reference (`dev` Environment)

The following variables can be customized in `environments/dev/terraform.tfvars`:

| Variable | Description | Default / Example Value |
| :--- | :--- | :--- |
| `aws_region` | Target AWS Region | `"us-east-1"` |
| `project_name` | Project prefix for resource naming | `"enterprise-gitops"` |
| `environment` | Environment identifier | `"dev"` |
| `cluster_version` | EKS Kubernetes version | `"1.33"` |
| `vpc_cidr` | Network IPv4 CIDR | `"10.0.0.0/16"` |
| `availability_zones` | Availability Zones for subnets | `["us-east-1a", "us-east-1b"]` |
| `public_subnet_cidrs` | Public Subnet CIDRs | `["10.0.1.0/24", "10.0.2.0/24"]` |
| `private_subnet_cidrs` | Private Subnet CIDRs | `["10.0.11.0/24", "10.0.12.0/24"]` |
| `instance_types` | EC2 Instance Type(s) for nodes | `["t3.small"]` |
| `capacity_type` | EC2 Capacity Type (`ON_DEMAND` or `SPOT`) | `"ON_DEMAND"` |
| `desired_size` | Initial Node count | `3` |
| `min_size` | Minimum Node count | `2` |
| `max_size` | Maximum Node count | `4` |

---

## 📤 Environment Outputs

Upon successful deployment, the `dev` environment outputs key configuration details:

| Output | Description |
| :--- | :--- |
| `cluster_name` | Name of the Amazon EKS cluster |
| `cluster_endpoint` | Endpoint URL for EKS Control Plane API |
| `cluster_arn` | Amazon Resource Name (ARN) of the cluster |
| `vpc_id` | Created AWS VPC ID |
| `configure_kubectl` | CLI command to update local `kubeconfig` |

---

## 🧹 Teardown Instructions

To clean up and destroy all provisioned AWS infrastructure to avoid ongoing charges:

```bash
# 1. Destroy Dev Environment
cd environments/dev
terraform destroy

# 2. (Optional) Destroy Remote State Bootstrap
cd ../../bootstrap
terraform destroy
```

---

## 📝 License

This project is open-source and available under the **MIT License**.