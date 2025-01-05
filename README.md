# Terraform AWS Infrastructure Setup

This repository contains Terraform scripts to create and manage AWS infrastructure. The repository includes two configurations:

1. **Mumbai Region Configuration**: Launches multiple EC2 instances within an existing VPC.
2. **North Virginia Configuration**: Sets up a complete VPC with public and private subnets, route tables, NAT Gateway, and instances in each subnet.

---

## Features

### Mumbai Region Configuration
- Launches EC2 instances in a specified VPC.
- Configurable instance count, instance type, and name prefix.
- Security group allowing HTTP, HTTPS, and RDP traffic.

### North Virginia Configuration
- Creates a VPC with CIDR block `10.0.0.0/16`.
- Configures public and private subnets.
- Sets up an Internet Gateway and a NAT Gateway for internet access.
- Associates route tables with subnets.
- Launches:
  - A public EC2 instance with a public IP.
  - A private EC2 instance with no public IP.

---

## Getting Started

### Pre-requisites
- [Terraform](https://www.terraform.io/downloads.html) installed.
- AWS CLI configured with sufficient permissions.
- Access to an AWS Key Pair for EC2 instances.

---

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/iratusbison/terraform_basics.git
   
   ```

2. **Navigate to the desired configuration folder:**
   - **Mumbai Region Configuration**: `basic_module_1/`
   - **North Virginia Configuration**: `vpcmodule/`

3. **Update the `variables` in `main.tf`:**
   - Replace placeholder values:
     - `ami_id` with your desired AMI ID.
     - `vpc_id` with your existing VPC ID (for Mumbai configuration).
     - `key_name` with your AWS Key Pair name.

4. **Initialize Terraform:**
   ```bash
   terraform init
   ```

5. **Apply the configuration:**
   ```bash
   terraform apply
   ```
   - Review the changes and type `yes` to proceed.

6. **Outputs**:
   - Public IPs of instances (if applicable).
   - Instance IDs.

---

### Directory Structure
```
terraform-aws-setup/
│
├── mumbai-config/
│   └── main.tf           # Terraform script for Mumbai region
│
├── north-virginia-config/
│   └── main.tf           # Terraform script for North Virginia setup
│
└── README.md             # Documentation
```

---

## Usage Notes
1. Ensure you replace sensitive information with actual values.
2. Use `.gitignore` to prevent committing sensitive files, e.g., `.pem` keys.

---

## Security Best Practices
- Avoid hardcoding sensitive information in Terraform files.
- Store sensitive values in environment variables or use AWS Secrets Manager.
- Regularly review and update the Terraform scripts to adhere to best practices.

---

## Resources Created

### Mumbai Configuration:
- Security Group allowing HTTP, HTTPS, and RDP traffic.
- EC2 instances with configurable count.

### North Virginia Configuration:
- VPC with CIDR `10.0.0.0/16`.
- Public and private subnets.
- Internet Gateway and NAT Gateway.
- Public and private route tables.
- EC2 instances in public and private subnets.

---

## Contributing
Contributions are welcome! Please submit a pull request for improvements.

---



