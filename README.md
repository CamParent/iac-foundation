# Azure IaC Foundation — Modular Hub-Spoke Deployment Framework

This repository defines a **modular, production-ready Azure infrastructure** built entirely with **Bicep**, following  
best practices for **Infrastructure-as-Code (IaC)** and **GitHub Actions-based CI/CD validation**.

It provisions a **hub-and-spoke network architecture** designed for enterprise workloads—centralizing security, shared services, and network management—while allowing flexible expansion for new applications and environments.

**Highlights**
- **Modular Bicep Design** – Reusable templates for networking, security, and shared services
- **CI/CD Integration** – Automated syntax validation and what-if deployments via GitHub Actions
- **Enterprise-Grade Architecture** – Hub-spoke topology with Azure Firewall, Key Vault, and resource isolation
- **Future-Ready Expansion** – Supports optional integrations such as Bastion, VPN Gateway, and Application Gateway + WAF

[![Bicep Validation](https://github.com/CamParent/iac-foundation/actions/workflows/bicep-validate.yml/badge.svg)](https://github.com/CamParent/iac-foundation/actions/workflows/bicep-validate.yml)

---

## Architecture

```mermaid
graph TD
  A[Azure Subscription] --> B[Hub Resource Group\nrg-hub-networking]
  B --> C[Hub VNet\n10.1.0.0/16]
  C --> D[Azure Firewall\nStandard/Premium]
  C --> E[Management Subnet\nsn-hub-mgmt]
  C --> F[Workloads Subnet\nsn-hub-workloads]
  B --> G[Firewall Subnet\nAzureFirewallSubnet]

  A --> H[Spoke Resource Group\nrg-spoke-app]
  H --> I[Spoke VNet\n10.2.0.0/16]
  I --> J[App Subnet\nsn-app]

  A --> K[Shared Resource Group\nrg-shared-services]
  K --> L[Key Vault\ncert-store-615]

  C <-->|VNet Peering| I
```
> **Note:** Future integrations (VPN Gateway, Bastion, Application Gateway + WAF, Private Endpoints) are planned for modular expansion.

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

## Validate

Preview deployment changes:
```bash
az deployment sub what-if `
  --location eastus2 `
  --template-file .\main.bicep `
  --parameters namePrefixHub=hub namePrefixSpoke=spoke-app
```

## Deploy
```bash
az deployment sub create `
  --location eastus2 `
  --template-file .\main.bicep `
  --parameters namePrefixHub=hub namePrefixSpoke=spoke-app
```

## Expected Results

- Hub and Spoke VNets created and peered
- Azure Firewall with static public IP
- Optional Key Vault provisioned
- Consistent tagging across resource groups

## CI/CD Integration

This repository includes a GitHub Actions workflow that:

- Runs syntax validation on all Bicep templates

- Executes an automated Azure “what-if” deployment preview

- Authenticates securely using OpenID Connect (OIDC) federation with Azure

## Next Steps

- Integrate Azure Policy for compliance and governance
- Extend CI/CD pipelines for automated deployments
- Add Azure Bastion and Application Gateway + WAF for production readiness
- Connect Log Analytics + Azure Monitor for observability

Author

Cameron Parent — Network & Cloud Engineer • Azure Security Engineer • CISSP

LinkedIn: https://www.linkedin.com/in/camjosephparent/
