# Azure IaC Foundation — Hub-Spoke Architecture

This repository defines a modular, production-ready Azure environment using **Bicep**.  
It implements a **hub-and-spoke** network with centralized security, shared services, and app isolation.

---

## Architecture

### Hub Network (`rg-hub-networking`)
- Central VNet for shared infra
- Subnets: `AzureFirewallSubnet`, `sn-hub-mgmt`, `sn-hub-workloads`
- Azure Firewall (Standard or Premium)

### Spoke Network (`rg-spoke-app`)
- Application VNet with dedicated app subnet
- Bidirectional peering with the hub

### Shared Services (`rg-shared-services`)
- Azure Key Vault for certificates and secrets

**Future-ready**: VPN/ExpressRoute Gateways, Bastion, Application Gateway + WAF, Private Endpoints.

---

## Repository Layout

.
├─ main.bicep # Subscription-scope orchestration
└─ modules/
├─ networking.bicep # Hub VNet + subnets
├─ spoke-networking.bicep # Spoke VNet + app subnet
├─ firewall.bicep # Azure Firewall
├─ keyvault.bicep # Shared Key Vault (optional)
└─ peering.bicep # Hub ↔ Spoke VNet peering


---

## Prerequisites

- Azure CLI (logged in)  
  ```bash
  az login

    Bicep CLI ≥ 0.38

    az bicep version

    Permissions to create Resource Groups, Networking, Azure Firewall, and Key Vault.

Validate

Preview deployment changes:

az deployment sub what-if `
  --location eastus2 `
  --template-file .\main.bicep `
  --parameters namePrefixHub=hub namePrefixSpoke=spoke-app

Deploy

az deployment sub create `
  --location eastus2 `
  --template-file .\main.bicep `
  --parameters namePrefixHub=hub namePrefixSpoke=spoke-app

Expected Results

    Hub and Spoke VNets created and peered

    Azure Firewall with static public IP

    Optional Key Vault provisioned

    Consistent tagging across resource groups

Next Steps

    Add GitHub Actions for CI/CD validation (what-if + lint).

    Apply Azure Policy for governance/compliance.

    Add Application Gateway + WAF for web tier.

    Integrate Azure Monitor + Log Analytics.

Author

Cameron Parent — Network & Cloud Engineer • Azure Security Engineer • CISSP

LinkedIn: https://www.linkedin.com/in/camjosephparent/
