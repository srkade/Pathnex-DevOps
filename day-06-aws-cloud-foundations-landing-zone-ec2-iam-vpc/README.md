# Day 6: AWS Cloud Foundations — Landing Zone, Control Tower, EC2, IAM & VPC

**Date:** Oct 06  
**Topic:** Multi-Account Architecture (Landing Zone vs Control Tower), IAM Security & Access Governance, Compute with Amazon EC2, and Cloud Networking with Amazon VPC.

---

## 1. AWS Multi-Account Strategy: Landing Zone & Control Tower

When companies adopt the cloud at scale, running everything in a single AWS account is dangerous for security, billing, and isolation. AWS recommends a **Multi-Account Architecture**.

```
                           +-------------------------------------+
                           |        AWS Organizations Root       |
                           +-------------------------------------+
                                              |
                 +----------------------------+----------------------------+
                 |                                                         |
  +-----------------------------+                           +-----------------------------+
  |    Core / Shared OU         |                           |    Workloads / App OU       |
  +-----------------------------+                           +-----------------------------+
  |  • Log Archive Account      |                           |  • Development Account      |
  |  • Security / Audit Account |                           |  • Staging / QA Account     |
  |  • Shared Services Account  |                           |  • Production Account       |
  +-----------------------------+                           +-----------------------------+
```

---

### 1.1 What is an AWS Landing Zone?
* **Definition:** A **Landing Zone** is a pre-configured, secure, multi-account AWS environment based on AWS Well-Architected best practices.
* **Core Purpose:** Serves as the foundational baseline before deploying production workloads.

#### Key Highlights:
* **Account Isolation:** Separates environments (Dev, Test, Prod) and business units into separate AWS accounts using **AWS Organizations**.
* **Centralized Governance:** Consolidated billing, centralized log aggregation (CloudTrail & VPC Flow Logs), and centralized security monitoring (GuardDuty, Security Hub).
* **Consistent Security Baseline:** Enforces company-wide policies (e.g., disallowing public S3 buckets, enforcing encryption at rest).

---

### 1.2 What is AWS Control Tower?
* **Definition:** **AWS Control Tower** is a managed AWS service that automates the setup, governance, and ongoing management of a Landing Zone with a few clicks.

#### Key Capabilities:
* **Automated Setup:** Automatically creates standard Organization Units (OUs), core security accounts, and identity federation.
* **Guardrails (Governance Rules):**
  * *Preventive Guardrails:* Block non-compliant actions (implemented via Service Control Policies - SCPs).
  * *Detective Guardrails:* Monitor resources and flag non-compliance (implemented via AWS Config rules).
* **Account Factory:** A self-service portal to quickly provision new, pre-configured AWS accounts that automatically inherit security policies.
* **Central Dashboard:** Real-time visibility into multi-account compliance and security posture.

---

### 💡 Memory Trick & Real-World Analogy

| Term | Concept | Real-World Campus Analogy |
| :--- | :--- | :--- |
| **Landing Zone** | **The Blueprint & Foundation 🏗** | Designing the corporate office campus with separate buildings for HR, Finance, IT, and Security. |
| **Control Tower** | **The Building Manager & Security Head 👮** | Automates building construction, manages ID cards, enforces safety rules, and audits compliance. |

---

## 2. Core AWS Foundational Services

---

### 2.1 Amazon EC2 (Elastic Compute Cloud)

**Purpose:** Resizable, on-demand virtual compute servers in the cloud.

```
+---------------------------------------------------------------+
|                      EC2 Instance Components                  |
+---------------------------------------------------------------+
|  • AMI (Amazon Machine Image)  : OS Template (Ubuntu, Amazon Linux)
|  • Instance Type               : CPU & RAM Ratio (e.g. t2.micro)
|  • EBS Volume (Storage)        : Persistent Virtual Hard Drive
|  • Security Group (Firewall)   : Inbound / Outbound Port Rules
|  • Key Pair (.pem)             : SSH Asymmetric Authentication
+---------------------------------------------------------------+
```

#### A. EC2 Instance Families:
* **General Purpose (`t`, `m`):** Balanced compute, memory, and networking (e.g., `t3.micro`, `m5.large`).
* **Compute Optimized (`c`):** High-performance processors for batch processing, web servers (e.g., `c6i.xlarge`).
* **Memory Optimized (`r`):** High memory workloads like Redis, in-memory caches, databases (e.g., `r6g.large`).
* **Storage Optimized (`i`, `d`):** High sequential read/write access to large datasets on local NVMe storage.

#### B. EC2 Purchasing & Pricing Models:
1. **On-Demand:** Pay per second/hour with zero upfront commitment. Best for unpredictable workloads or initial testing.
2. **Reserved Instances (RI) / Savings Plans:** 1 to 3-year commitment offering up to 72% discount for steady-state workloads.
3. **Spot Instances:** Bid on spare AWS capacity at up to 90% discount. Ideal for fault-tolerant, stateless batch jobs.

---

### 2.2 AWS IAM (Identity and Access Management)

**Purpose:** Centrally manage authentication and authorization to AWS services and resources securely.

```
       [ User / Service ] ---> [ IAM Policy (JSON) ] ---> [ Allowed / Denied Access ]
```

#### Core Components of IAM:
1. **IAM Users:** Individual person or service account (e.g., `shree-devops`).
2. **IAM Groups:** Collection of users sharing identical permissions (e.g., `Developers`, `Admins`).
3. **IAM Roles:** Temporary credentials assumed by AWS services (e.g., an EC2 instance assuming a role to read an S3 bucket without hardcoded keys).
4. **IAM Policies:** JSON documents defining permissions.

#### Understanding IAM Policy Structure (PARC Model):
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3ReadAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-devops-bucket",
        "arn:aws:s3:::my-devops-bucket/*"
      ]
    }
  ]
}
```
* **Effect:** `Allow` or `Deny` (Explicit Deny always overrides Allow).
* **Action:** Specific API calls permitted (e.g., `ec2:RunInstances`, `s3:PutObject`).
* **Resource:** The ARN (Amazon Resource Name) target.
* **Condition:** Optional requirements (e.g., enforce MFA or restrict by IP range).

#### IAM Security Best Practices:
* **Lock away the Root Account:** Never use AWS root account for daily tasks; enable Multi-Factor Authentication (MFA).
* **Principle of Least Privilege:** Grant only the minimum permissions necessary to complete a task.
* **Use Roles instead of Long-lived Access Keys:** Avoid hardcoding AWS Access Keys (`AKIA...`) in code or EC2 instances.

---

### 2.3 Amazon VPC (Virtual Private Cloud)

**Purpose:** Provides a logically isolated virtual private network within the AWS cloud dedicated to your account.

```
+-------------------------------------------------------------------------------+
|                                  AWS Cloud                                    |
|  +-------------------------------------------------------------------------+  |
|  | VPC (10.0.0.0/16)                                                       |  |
|  |                                                                         |  |
|  |  +---------------------------+       +-------------------------------+  |  |
|  |  | Public Subnet (10.0.1.0/24)|       | Private Subnet (10.0.2.0/24)  |  |  |
|  |  |  - Internet Gateway (IGW) |       |  - No Direct Internet Route   |  |  |
|  |  |  - Public Nginx Web Server|       |  - Private App & Database     |  |  |
|  |  |  - NAT Gateway (Outbound) | ----> |  - Outbound via NAT Gateway   |  |  |
|  |  +---------------------------+       +-------------------------------+  |  |
|  |               |                                                         |  |
|  +---------------|---------------------------------------------------------+  |
+------------------|------------------------------------------------------------+
                   v
          [ Internet Gateway ] <---> (Public Internet)
```

#### Key Building Blocks of VPC:
1. **CIDR Block:** IP address range for the VPC (e.g., `10.0.0.0/16` provides 65,536 private IP addresses).
2. **Subnets:** Subdivisions of VPC tied to a specific Availability Zone (AZ):
   * **Public Subnet:** Has a direct route to the Internet Gateway (for load balancers, public web servers).
   * **Private Subnet:** Has no direct internet route (for databases, backend APIs, microservices).
3. **Internet Gateway (IGW):** Horizontally scaled VPC component allowing bidirectional communication between public subnets and the internet.
4. **NAT Gateway:** Network Address Translation service placed in a public subnet allowing private instances to download security patches/updates without exposing them to incoming internet traffic.
5. **Route Tables:** Set of rules determining where network traffic from a subnet is directed.

#### Security Groups vs Network Access Control Lists (NACLs):

| Feature | Security Group (SG) | Network ACL (NACL) |
| :--- | :--- | :--- |
| **Operating Level** | Instance level (Virtual NIC) | Subnet level |
| **State Nature** | **Stateful** (Return traffic is automatically allowed) | **Stateless** (Inbound & outbound rules evaluated separately) |
| **Rule Evaluation** | All rules evaluated before decision | Evaluated in strict numerical order (lowest first) |
| **Rule Types** | Supports `ALLOW` rules only | Supports both `ALLOW` and `DENY` rules |

---

## 3. Hands-on DevOps Practice Script

* [`scripts/aws_resource_audit.sh`](./scripts/aws_resource_audit.sh) — A bash utility script demonstrating how DevOps engineers inspect and validate EC2 instances, IAM configurations, and VPC subnets using the AWS CLI.
