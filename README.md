# Terraform-Ansible-Hadoop

Automated provisioning and configuration of a multi-node Hadoop cluster on AWS using **Terraform** for infrastructure and **Ansible** for software configuration.

---

## Overview

This project spins up a production-style Hadoop cluster on AWS EC2 with a single command. Terraform provisions the EC2 instances, and Ansible (running from a dedicated control node) installs and configures Hadoop across all cluster nodes.

**Default cluster layout (from `terraform.tfvars`):**

| Role | Count | Instance Type |
|---|---|---|
| Hadoop Nodes | 5 | t2.medium |
| Ansible Control Node | 1 | t2.medium |

---

## Architecture

```
┌─────────────────────────────────────────┐
│              AWS (ap-south-1)           │
│                                         │
│  ┌──────────────┐   ┌────────────────┐  │
│  │ Ansible Node │──▶│ Hadoop-Node-0  │  │
│  │  (Control)   │   ├────────────────┤  │
│  └──────────────┘   │ Hadoop-Node-1  │  │
│                     ├────────────────┤  │
│                     │ Hadoop-Node-2  │  │
│                     ├────────────────┤  │
│                     │ Hadoop-Node-3  │  │
│                     ├────────────────┤  │
│                     │ Hadoop-Node-4  │  │
│                     └────────────────┘  │
└─────────────────────────────────────────┘
```

- **Ansible Node** — acts as the Hadoop cluster manager / control plane. Runs Ansible playbooks to configure all Hadoop nodes.
- **Hadoop Nodes** — form the distributed HDFS and YARN cluster. Node-0 typically acts as the NameNode / ResourceManager; the rest are DataNodes / NodeManagers.

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/) >= 2.9
- An AWS account with programmatic access configured (`aws configure`)
- An existing EC2 Key Pair in the target region
- Python 3 on the Ansible control machine

---

## Project Structure

```
Terraform-Ansible-Hadoop/
├── main.tf                  # EC2 instance resources (Hadoop nodes + Ansible node)
├── variable.tf              # Input variable declarations
├── terraform.tfvars         # Default variable values
├── outputs.tf               # Outputs: public IPs of all nodes
├── providers.tf             # AWS provider configuration
├── ansible/                 # Ansible playbooks and roles
├── hadoop-cluster/          # Hadoop configuration templates
└── Hadoop-Cluster/          # Additional Hadoop cluster assets
```

---

## Configuration

Edit `terraform.tfvars` to customise your deployment:

```hcl
aws_region          = "ap-south-1"   # Target AWS region
key_name            = "KEYPAIR"      # Your EC2 Key Pair name
instance_type       = "t2.medium"    # Instance type for all nodes
hadoop_cluster_size = 5              # Number of Hadoop data nodes
ansible_node_count  = 1              # Number of Ansible control nodes
```

### Variables Reference

| Variable | Description | Default |
|---|---|---|
| `aws_region` | AWS region to deploy into | `ap-south-1` |
| `key_name` | EC2 Key Pair for SSH access | `KEYPAIR` |
| `instance_type` | EC2 instance type | `t2.medium` |
| `hadoop_cluster_size` | Number of Hadoop cluster nodes | `5` |
| `ansible_node_count` | Number of Ansible control nodes | `1` |

---

## Deployment

### 1. Clone the repository

```bash
git clone https://github.com/RajCloudify/Terraform-Ansible-Hadoop.git
cd Terraform-Ansible-Hadoop
```

### 2. Configure AWS credentials

```bash
aws configure
```

### 3. Update variables

Open `terraform.tfvars` and set your `key_name` and preferred region.

### 4. Initialise Terraform

```bash
terraform init
```

### 5. Preview the plan

```bash
terraform plan
```

### 6. Apply the infrastructure

```bash
terraform apply
```

Type `yes` when prompted. Terraform will provision all EC2 instances and print the public IPs on completion.

### 7. Run Ansible to configure Hadoop

SSH into the Ansible control node using the IP from Terraform output:

```bash
ssh -i your-key.pem ubuntu@<ansible_node_ip>
```

From the Ansible node, run the playbook:

```bash
cd /path/to/ansible
ansible-playbook -i inventory hadoop-setup.yml
```

---

## Outputs

After `terraform apply`, the following values are printed:

| Output | Description |
|---|---|
| `hadoop_nodes_ips` | List of public IPs for all Hadoop nodes |
| `ansible_node_ip` | Public IP of the Ansible control node |

---

## Teardown

To destroy all provisioned resources and avoid ongoing AWS charges:

```bash
terraform destroy
```

---

## Notes

- The AMI ID used (`ami-00bb6a80f01f03502`) is an Ubuntu image for `ap-south-1`. If deploying to a different region, update the AMI in `main.tf` with the appropriate Ubuntu AMI for that region.
- Ensure your AWS IAM user has `ec2:RunInstances`, `ec2:DescribeInstances`, and related EC2 permissions.
- For production use, consider placing instances within a VPC with private subnets and a bastion host, and restricting security group inbound rules.

---

## License

This project is open source. See the repository for details.
