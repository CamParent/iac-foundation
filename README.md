# Azure IaC Foundation — Hub-Spoke Architecture

This repository defines a modular, production-ready Azure environment using **Bicep**.  
It implements a **hub-and-spoke** network with centralized security, shared services, and app isolation.

[![Bicep Validation](https://github.com/CamParent/iac-foundation/actions/workflows/bicep-validate.yml/badge.svg)](https://github.com/CamParent/iac-foundation/actions/workflows/bicep-validate.yml)

---

## Architecture

```mermaid
graph TD
  A[Azure Subscription]
  B[Hub Resource Group<br/>rg-hub-networking]
  A --> B
  B --> C[Hub VNet<br/>10.1.0.0/16]
  C --> D[Azure Firewall<br/>Standard/Premium]
  C --> E[Management Subnet<br/>sn-hub-mgmt]
  C --> F[Workloads Subnet<br/>sn-hub-workloads]
  B --> G[Firewall Subnet<br/>AzureFirewallSubnet]

  A --> H[Spoke Resource Group<br/>rg-spoke-app]
  H --> I[Spoke VNet<br/>10.2.0.0/16]
  I --> J[App Subnet<br/>sn-app]

  A --> K[Shared Resource Group<br/>rg-shared-services]
  K --> L[Key Vault<br/>cert-store-615]

  C <-->|VNet Peering| I

  %% Optional integrations
  C -.-> M[VPN/ExpressRoute Gateway<br/>(optional)]
  C -.-> N[Azure Bastion<br/>(optional)]
  I -.-> O[Application Gateway + WAF<br/>(optional)]
  I -.-> P[Private Endpoint Integrations<br/>(optional)]

  %% Styling (nice Azure-ish look)
  classDef core fill:#e6f0ff,stroke:#2b6cb0,stroke-width:1px,color:#0a2540;
  classDef optional fill:#f2f2f2,stroke:#888,stroke-dasharray:3 2,color:#333;
  class A,B,C,D,E,F,G,H,I,J,K,L core;
  class M,N,O,P optional;
```

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

```text
.
├── main.bicep                  # Subscription-scope orchestration  
└── modules/
    ├── networking.bicep        # Hub VNet + subnets  
    ├── spoke-networking.bicep  # Spoke VNet + app subnet  
    ├── firewall.bicep          # Azure Firewall deployment    
    ├── keyvault.bicep          # Shared Key Vault (optional)    
    └── peering.bicep           # Hub ↔ Spoke VNet peering
```

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
