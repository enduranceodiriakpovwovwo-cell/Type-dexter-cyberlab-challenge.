# 📑 Project Master Blueprint: Dexter CyberLab Challenge
**Position:** Cloud & Infrastructure Engineer  
**Target Market:** Nigerian Fintech (Digital Wallet)  

---

## 🏗️ Section 1: Architecture Design

### 1. VPC Design & Network Isolation
* **Public Subnets:** Hosts the AWS Application Load Balancer (ALB) and NAT Gateway. The ALB is the only public entry point for incoming mobile wallet traffic.
* **Private Subnets (Application Layer):** Houses the backend application containers. Isolated from direct internet access, utilizing the NAT Gateway strictly for outbound traffic (e.g., pulling secure updates or connecting to KYC verification endpoints).
* **Isolated Subnets (Data Layer):** The database tier has zero public internet access and only accepts traffic over port 5432 originating strictly from the application containers.

### 2. Compute Choice: AWS ECS with Fargate
* **Rationale:** Minimizes operational infrastructure management for a lean, rapid fintech deployment in Nigeria. Eliminates the overhead of scaling, patching, and provisioning physical EC2 instances or maintaining complex EKS control planes, allowing a primary focus on secure product engineering.

### 3. Managed Database & High Availability
* **Storage:** Amazon RDS PostgreSQL in a Multi-AZ framework. If a primary data center suffers an outage, traffic dynamically shifts to a hot standby in an alternate zone.
* **Backups:** Automated daily snapshots retained for 30 days, coupled with continuous transaction log shipping to secure Amazon S3 buckets for point-in-time recovery (PITR).

### 4. Secrets Management & Security Posture
* **Zero Hardcoded Secrets:** AWS Secrets Manager is utilized to securely manage and rotate sensitive credentials, JWT keys, and third-party KYC API tokens. Containers consume these variables dynamically at runtime via strict IAM execution roles.
* **IAM Least Privilege:** Every backend service functions under tightly scoped IAM policies allowing only the bare minimum actions needed for operation.

---

## 🛰️ Section 2: Starlink Connectivity Ops Plan

* **Monitoring Architecture:** To manage a distributed fleet of Starlink terminals across multiple operational remote sites, we deploy lightweight Prometheus network exporters or localized monitoring agents.
* **Key Metrics Tracked:** We query the built-in Starlink gRPC metrics endpoints to actively monitor real-time latency anomalies, packet loss percentages, dish obstruction percentages, and overall link uptime.
* **Alerting Framework:** These data metrics flow directly into a central Grafana dashboard. Automated alerting thresholds are configured to dispatch high-priority alerts via PagerDuty or Slack if any remote terminal drops offline or demonstrates a severely degraded connection for more than 2 consecutive minutes.
