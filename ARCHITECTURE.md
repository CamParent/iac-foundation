# 🏗️ Architecture Overview

![Azure](https://img.shields.io/badge/Azure-Cloud-blue)
![Bicep](https://img.shields.io/badge/IaC-Bicep-512BD4)
![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC)
![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF)
![Zero Trust](https://img.shields.io/badge/Security-Zero%20Trust-success)

---

## High-Level Design

This project implements a **hub-and-spoke Azure architecture** aligned with enterprise and Zero Trust best practices.

The design separates **shared infrastructure** from **workload environments**, enabling strong isolation, centralized control, and scalable growth.

---

## Logical Architecture Diagram

```mermaid
flowchart TD
    subgraph Subscription["Azure Subscription"]
        subgraph HubRG["Hub Resource Group"]
            HubVNet["Hub VNet"]
            Firewall["Azure Firewall (Optional)"]
            Bastion["Azure Bastion (Optional)"]
            Log["Log Analytics / Sentinel"]
        end

        subgraph SpokeRG["Spoke Resource Group"]
            SpokeVNet["Spoke VNet"]
            AKS["AKS Cluster (Optional)"]
            App["Sample Workloads"]
        end

        HubVNet --- SpokeVNet
        HubVNet --> Firewall
        HubVNet --> Log
        SpokeVNet --> AKS
        SpokeVNet --> App
    end
```

---

## Design Principles

### 🔒 Security First
- Centralized ingress/egress via hub
- Optional Azure Firewall for traffic inspection
- Private endpoints and private AKS by default
- Identity-driven access (Entra ID / RBAC)

### 🧩 Modularity
- Each component deploys independently
- Features enabled via parameters and workflow toggles
- Easy to extend without refactoring core architecture

### 💸 Cost Awareness
- Expensive services are **explicitly opt-in**
- Safe baseline deployment suitable for labs and demos
- CI/CD enforces intentional resource deployment

### ⚙️ Automation & Governance
- Infrastructure deployed via GitHub Actions (OIDC)
- Azure Policy enforces baseline governance
- Sentinel enables visibility and detection-as-code

---

## Mapping to Real-World Azure Patterns

This architecture mirrors common enterprise patterns:
- Landing zones / platform teams
- Shared services hub
- Isolated application spokes
- Policy-driven governance
- Security operations integration

---

> This document focuses on **architecture intent and structure**.  
> Deployment steps and configuration details are covered in other docs.
