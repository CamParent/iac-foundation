# Azure IaC Foundation — Hub-Spoke Architecture

This repository defines a modular, production-ready Azure environment using **Bicep**.  
It implements a **hub-and-spoke** network with centralized security, shared services, and app isolation.

[![Bicep Validation](https://github.com/CamParent/iac-foundation/actions/workflows/bicep-validate.yml/badge.svg)](https://github.com/CamParent/iac-foundation/actions/workflows/bicep-validate.yml)

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

├── main.bicep                  # Subscription-scope orchestration  
└── modules/
    ├── networking.bicep        # Hub VNet + subnets  
    ├── spoke-networking.bicep  # Spoke VNet + app subnet  
    ├── firewall.bicep          # Azure Firewall deployment    
    ├── keyvault.bicep          # Shared Key Vault (optional)    
    └── peering.bicep           # Hub ↔ Spoke VNet peering

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

CI/CD Integration

This repository includes a GitHub Actions workflow that:

    Runs syntax validation on all Bicep templates

    Executes an automated Azure “what-if” deployment preview

    Authenticates securely using OpenID Connect (OIDC) federation with Azure

Next Steps

    Apply Azure Policy for governance and compliance

    Extend monitoring with Azure Monitor + Log Analytics

    Integrate Application Gateway + WAF for web-tier security

    Add Automated CI/CD Deployment pipelines

Author

Cameron Parent — Network & Cloud Engineer • Azure Security Engineer • CISSP

LinkedIn: https://www.linkedin.com/in/camjosephparent/
