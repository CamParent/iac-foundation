# 🌐 Azure IaC Foundation — Hub-Spoke Architecture

## Overview
This repository defines a **modular, production-ready Azure environment** using **Bicep** for Infrastructure-as-Code.  
It follows the **hub-and-spoke network model**, incorporating centralized security, shared services, and application isolation.

---

## Architecture

### Core Components

#### 🏢 Hub Network (`rg-hub-networking`)
- Central virtual network hosting shared infrastructure  
- Subnets: `AzureFirewallSubnet`, `sn-hub-mgmt`, `sn-hub-workloads`  
- Azure Firewall (Standard/Premium SKU)

#### 🌐 Spoke Network (`rg-spoke-app`)
- Application virtual network with dedicated subnet for workloads  
- Peered bidirectionally with the hub

#### 🔐 Shared Services (`rg-shared-services`)
- Azure Key Vault for secure certificate and secret management

#### 🧱 Resource Groups
- Each layer isolated for clear management and RBAC boundaries

### Expandable Topology
This design supports future expansion into:
- VPN/ExpressRoute gateways  
- Azure Bastion  
- Application Gateway + WAF  
- Private Endpoints and Service Networking

---

## Repository Structure

.
├── main.bicep # Root orchestration file (subscription scope)
└── modules/
├── networking.bicep # Hub VNet and subnets
├── spoke-networking.bicep # Spoke VNet and subnet
├── firewall.bicep # Azure Firewall deployment
├── keyvault.bicep # Shared Key Vault (optional)
└── peering.bicep # Hub ↔ Spoke VNet peering


---

## Deployment

### Prerequisites
- **Azure CLI** installed and logged in  
  ```powershell
  az login

    Bicep CLI ≥ 0.38.0

    az bicep version

    Sufficient permissions to create:

        Resource Groups

        Networking resources

        Azure Firewall

        Key Vault

Validate Configuration

Preview what will be created:

az deployment sub what-if `
  --location eastus2 `
  --template-file .\main.bicep `
  --parameters namePrefixHub=hub namePrefixSpoke=spoke-app

Deploy

az deployment sub create `
  --location eastus2 `
  --template-file .\main.bicep `
  --parameters namePrefixHub=hub namePrefixSpoke=spoke-app

Expected Outputs

    Hub and Spoke VNets created and peered

    Azure Firewall deployed with static public IP

    Optional Key Vault provisioned

    Resource groups tagged and consistent

Next Steps

    Integrate with GitHub Actions for CI/CD validation and linting

    Add Azure Policy for governance and compliance

    Introduce Application Gateway + WAF for web-tier security

    Extend to include Azure Monitor and Log Analytics

Author

Cameron Parent
Network & Cloud Engineer | Azure Security Engineer | CISSP
☁️ Microsoft Azure | Cisco | ISC²
🔗 LinkedIn https://www.linkedin.com/in/camjosephparent/
