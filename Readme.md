# Terraform ITI Project

This project demonstrates the use of Terraform to provision AWS infrastructure, including VPC, subnets, security groups, EC2 instances, RDS, and more. The infrastructure is designed to support multiple environments (`dev` and `prod`) with separate configurations.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Infrastructure Components](#infrastructure-components)
3. [Environment Configuration](#environment-configuration)
4. [Modules and Files](#modules-and-files)
5. [How to Use](#how-to-use)
6. [Security Best Practices](#security-best-practices)

---

## Project Overview

This project provisions the following AWS resources:

- A VPC with public and private subnets.
- Security groups for SSH, application access, and RDS.
- EC2 instances for a bastion host and application server.
- An RDS MySQL database in private subnets.
- A NAT Gateway for internet access from private subnets.
- S3 backend for storing Terraform state files.

The infrastructure supports two environments (`dev` and `prod`) with region-specific configurations.

---

## Infrastructure Components

### 1. **Networking**

- **VPC**: A single VPC (`aws_vpc.application`) with a CIDR block of `10.0.0.0/16`.
- **Subnets**:
  - Two public subnets (`public_subnet-1` and `public_subnet-2`) for the bastion host and NAT Gateway.
  - Two private subnets (`private_subnet-1` and `private_subnet-2`) for the application server and RDS.
- **Route Tables**:
  - A public route table (`public`) associated with the public subnets.
  - A private route table (`private_rt`) associated with the private subnets, routing traffic through a NAT Gateway.
- **NAT Gateway**: Provides internet access for resources in private subnets.

### 2. **Security Groups**

- **allow_ssh**: Allows SSH access (port 22) from anywhere.
- **allow_ssh_port**: Allows SSH (port 22) and application traffic (port 3000) from specific sources.
- **rds_sg**: Allows MySQL traffic (port 3306) within the VPC.

### 3. **Compute**

- **Bastion Host**: An EC2 instance in the public subnet for secure SSH access to private resources.
- **Application Server**: An EC2 instance in the private subnet for running the application.

### 4. **Database**

- **RDS MySQL**: A managed MySQL database deployed in private subnets with a subnet group and security group.

### 5. **State Management**

- **S3 Backend**: Stores Terraform state files in an S3 bucket (`terraform-state-bucket-abdo2322`) with encryption enabled.

---

## Environment Configuration

### Variables

- Variables are defined in `variables.tf` and configured for each environment using `.tfvars` files:
  - `dev.tfvars`: Configuration for the `dev` environment (e.g., `us-east-1` region).
  - `prod.tfvars`: Configuration for the `prod` environment (e.g., `eu-central-1` region).

### Workspaces

- Terraform workspaces are used to manage multiple environments (`dev` and `prod`).

---

## Modules and Files

### Key Files

1. **`main.tf`**:

   - Defines the AWS provider and S3 bucket for Terraform state management.

2. **`networking.tf`**:

   - Provisions the VPC, subnets, route tables, NAT Gateway, and associations.

3. **`sg.tf`**:

   - Defines security groups for SSH, application traffic, and RDS.

4. **`instances.tf`**:

   - Provisions EC2 instances for the bastion host and application server.

5. **`rds.tf`**:

   - Provisions the RDS MySQL database with a subnet group and security group.

6. **`variables.tf`**:

   - Declares variables for AMI, region, database credentials, etc.

7. **`dev.tfvars` and `prod.tfvars`**:

   - Provide environment-specific values for variables.

8. **`backend.tf`**:

   - Configures the S3 backend for storing Terraform state files.

9. **`.gitignore`**:

   - Excludes sensitive files (e.g., `.tfvars`, private keys) from version control.

10. **`key_pair.tf`**:

    - Creates an SSH key pair for accessing EC2 instances.

11. **`bastion_ip.txt`**:
    - Stores the public IP of the bastion host, generated using a `local-exec` provisioner.

---

## How to Use

### Prerequisites

- Install Terraform.
- Configure AWS CLI with appropriate credentials.

### Steps

1. **Initialize Terraform**:

   ```bash
   terraform init
   ```

2. **Select Workspace**:

   ```bash
   terraform workspace select dev
   ```

   Replace `dev` with `prod` for the production environment.

3. **Plan the Infrastructure**:

   ```bash
   terraform plan -var-file="dev.tfvars"
   ```

   Replace `dev.tfvars` with `prod.tfvars` for the production environment.

4. **Apply the Configuration**:

   ```bash
   terraform apply -var-file="dev.tfvars"
   ```

   Confirm the changes when prompted.

5. **Access the Bastion Host**:

   - Retrieve the bastion host's public IP from `bastion_ip.txt`.
   - Use the SSH key pair to connect:
     ```bash
     ssh -i <path-to-private-key> ec2-user@<bastion-public-ip>
     ```

6. **Destroy the Infrastructure**:
   To clean up resources:
   ```bash
   terraform destroy -var-file="dev.tfvars"
   ```
   Replace `dev.tfvars` with `prod.tfvars` for the production environment.

---

## Security Best Practices

1. **Use IAM Roles**:

   - Assign IAM roles to EC2 instances instead of using access keys.

2. **Secure State Files**:

   - Enable encryption for the S3 bucket storing Terraform state files.
   - Use bucket policies to restrict access.

3. **Restrict Security Group Rules**:

   - Limit SSH access to specific IP ranges.
   - Avoid using `0.0.0.0/0` unless necessary.

4. **Store Secrets Securely**:

   - Use AWS Secrets Manager or Parameter Store for sensitive data like database credentials.

5. **Enable Logging**:

   - Enable CloudTrail and VPC Flow Logs for monitoring and auditing.

6. **Regularly Rotate Keys**:
   - Rotate SSH keys and access keys periodically.

---
