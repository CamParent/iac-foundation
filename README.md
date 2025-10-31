<p align="center">
  <h1>🌐 Azure IaC Foundation — Hub-Spoke Architecture</h1>
  <p><b>Modular Infrastructure-as-Code with Azure Bicep</b></p>

  <img src="https://img.shields.io/badge/Azure-0078D4?logo=microsoftazure&logoColor=white">
  <img src="https://img.shields.io/badge/Bicep-IaC-blue">
  <img src="https://img.shields.io/badge/CISSP-ISC2-brightgreen">
  <img src="https://img.shields.io/badge/license-MIT-lightgrey">
</p>

---

## 🏗️ Overview

This repository defines a **modular, production-ready Azure environment** using **Bicep** for Infrastructure-as-Code (IaC).  
It follows the **hub-and-spoke network topology**, incorporating centralized security, shared services, and application isolation.

---

## 🧩 Architecture

### **Core Components**

#### **Hub Network (`rg-hub-networking`)**
- Central virtual network hosting shared infrastructure
- Subnets:
  - `AzureFirewallSubnet`
  - `sn-hub-mgmt`
  - `sn-hub-workloads`
- Azure Firewall (Standard or Premium SKU)

#### **Spoke Network (`rg-spoke-app`)**
- Application virtual network with dedicated app subnet
- Bidirectional VNet peering with the hub

#### **Shared Services (`rg-shared-services`)**
- Azure Key Vault for secure certificate and secret management

#### **Resource Groups**
- Clear separation for management, security, and RBAC boundaries

#### **Future Expansion Support**
- VPN / ExpressRoute Gateways  
- Azure Bastion  
- Application Gateway + WAF  
- Private Endpoints & Service Networking  

---

## 🧱 Repository Structure

.
├── main.bicep # Root orchestration file (subscription scope)
└── modules/
├── networking.bicep # Hub VNet and subnets
├── spoke-networking.bicep # Spoke VNet and subnet
├── firewall.bicep # Azure Firewall deployment
├── keyvault.bicep # Shared Key Vault (optional)
└── peering.bicep # Hub ↔ Spoke VNet peering


---

## 🚀 Deployment Prerequisites

### **Azure CLI**
Make sure you’re logged in:
```bash
az login

Bicep CLI ≥ 0.38.0

Check your version:

az bicep version

Required Permissions

You must have access to create:

    Resource Groups

    Networking Resources

    Azure Firewall

    Key Vault

⚙️ Validate Configuration

Preview deployment changes before execution:

az deployment sub what-if `
  --location eastus2 `
  --template-file .\main.bicep `
  --parameters namePrefixHub=hub namePrefixSpoke=spoke-app

🚢 Deploy

Execute deployment:

az deployment sub create `
  --location eastus2 `
  --template-file .\main.bicep `
  --parameters namePrefixHub=hub namePrefixSpoke=spoke-app

✅ Expected Outputs

    Hub and Spoke VNets created and peered

    Azure Firewall deployed with static public IP

    Optional Key Vault provisioned

    Consistent tagging across all resource groups

🔄 Next Steps

    Integrate with GitHub Actions for CI/CD validation and linting

    Add Azure Policy for governance and compliance

    Deploy Application Gateway + WAF for web-tier security

    Extend monitoring with Azure Monitor and Log Analytics

👤 Author

Cameron Parent
Network & Cloud Engineer • Azure Security Engineer • CISSP

🔗 LinkedIn Profile

☁️ Microsoft Azure | ISC²