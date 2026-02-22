# AWS Multi-VPC Architecture using Terraform

## 📌 Overview

This project implements an enterprise-grade AWS Multi-VPC architecture using Terraform.  
Production workloads are isolated in private subnets, and internet access is centralized through a dedicated Network VPC using Transit Gateway.

---

## 🏗️ Architecture Summary

### 🔹 Production VPC
- CIDR: 10.0.0.0/16
- 3 Private Subnets
- No Internet Gateway
- Default route → Transit Gateway
- Internet access via Network VPC NAT

### 🔹 Network VPC
- CIDR: 10.100.0.0/16
- Public & Private Subnets
- Internet Gateway
- NAT Gateway
- Elastic IP

Acts as centralized internet egress hub.

---

## 🔄 Traffic Flow

Production EC2  
→ Transit Gateway  
→ Network VPC NAT  
→ Internet Gateway  
→ Internet  

✔ No direct public exposure  
✔ Secure outbound internet access  

---

## 🌐 Transit Gateway

- Connects Production and Network VPC
- Manual route table configuration
- Explicit CIDR routing for full control

---

## ☁️ Services Used

- Amazon VPC  
- AWS Transit Gateway  
- NAT Gateway  
- Internet Gateway  
- Elastic IP  

---

## 📂 Structure
