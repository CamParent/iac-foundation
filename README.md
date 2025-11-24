# Azure IaC Foundation — Modular Hub-Spoke Deployment Framework
[![Bicep Validation](https://github.com/CamParent/iac-foundation/actions/workflows/bicep-validate.yml/badge.svg)](https://github.com/CamParent/iac-foundation/actions/workflows/bicep-validate.yml)

This repository defines a **modular, production-ready Azure infrastructure** built entirely with **Bicep**, following  
best practices for **Infrastructure-as-Code (IaC)** and **GitHub Actions-based CI/CD validation**.

It provisions a **hub-and-spoke network architecture** designed for enterprise workloads—centralizing security, shared services, and network management—while allowing flexible expansion for new applications and environments.

**Highlights**
- **Modular Bicep Design** – Reusable templates for networking, security, and shared services
- **CI/CD Integration** – Automated syntax validation and what-if deployments via GitHub Actions
- **Enterprise-Grade Architecture** – Hub-spoke topology with Azure Firewall, Key Vault, and resource isolation
- **Future-Ready Expansion** – Supports optional integrations such as Bastion, VPN Gateway, and Application Gateway + WAF
- **Private AKS Cluster Deployment (optional)** – Azure Kubernetes Service deployed using modular Bicep, Cilium dataplane, Azure CNI overlay, Azure AD integration with RBAC


---

## Architecture

```mermaid
graph TD
  A[Azure Subscription] --> B[Hub Resource Group\nrg-hub-networking]
  B --> C[Hub VNet\n10.1.0.0/16]
  C --> D[Azure Firewall\nStandard (Deny mode)]
  C --> E[Management Subnet\nsn-hub-mgmt]
  C --> F[Workloads Subnet\nsn-hub-workloads]
  B --> G[Firewall Subnet\nAzureFirewallSubnet]

  A --> H[Spoke Resource Group\nrg-spoke-app]
  H --> I[Spoke VNet\n10.2.0.0/16]
  I --> J[App Subnet\nsn-spoke-app-app]
  I --> M[AKS Subnet\nsn-spoke-app-aks]

  A --> K[Shared Resource Group\nrg-shared-services]
  K --> L[Key Vault\nkv-cert-store-615]

  C <-->|VNet Peering| I

  %% Optional AKS deployment
  M --> N[AKS Cluster\nspoke-app-aks\nPrivate, Cilium, Azure AD RBAC]
```
> **Note:** 
AKS deployment is optional via the deployAks=true parameter.
The cluster uses Azure CNI Overlay, Cilium dataplane, system-assigned identity, and private API access via Private Link.
Future proposed integrations: VPN Gateway, Azure Bastion, Application Gateway + WAF, Additional Private Endpoints, and Log Analytics / Azure Monitor.

### Hub Network (`rg-hub-networking`)
- Central VNet for shared infra
- Subnets: `AzureFirewallSubnet`, `sn-hub-mgmt`, `sn-hub-workloads`
- Azure Firewall (Standard or Premium)

### Spoke Network (`rg-spoke-app`)
- Application VNet with dedicated app subnet
- Bidirectional peering with the hub
- Optionally deploys a private AKS cluster (`spoke-app-aks`) using Azure CNI Overlay + Cilium dataplane
- AKS control plane exposed via `privatelink`, not publicly accessible
- Secured via Azure AD + Kubernetes RBAC

### Shared Services (`rg-shared-services`)
- Azure Key Vault for certificates and secrets

**Future-ready**: VPN/ExpressRoute Gateways, Bastion, Application Gateway + WAF, Private Endpoints.

---

## Repository Layout

```text
.
├── main.bicep                      # Subscription-scope orchestration
├── modules/
│   ├── networking.bicep            # Hub VNet + subnets
│   ├── spoke-networking.bicep      # Spoke VNet + app subnet
│   ├── firewall.bicep              # Azure Firewall deployment
│   ├── keyvault.bicep              # Shared Key Vault (optional)
│   ├── policy.bicep                # Azure Policy (defs + assignments wired to JSON)
│   ├── peering.bicep               # Hub ↔ Spoke VNet peering
│   └── aks.bicep                   # Optional AKS cluster deployment
├── policies/
│   ├── allowed-locations.json      # Custom policy: restrict regions
│   ├── enforce-tags.json           # Custom policy: require tag keys
│   └── require-standard-publicip.json  # Custom policy: enforce Standard SKU Public IPs
└── .github/
    └── workflows/
        └── bicep-validate.yml      # CI: bicep build + what-if (OIDC login)
```

---

## Prerequisites

- Azure CLI (logged in)  
```bash
az login
```

- Bicep CLI ≥ 0.38
```bash
az bicep version
```

- Permissions to create:
  - Resource Groups
  - Virtual Networks
  - Azure Firewall
  - Key Vault

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

## AKS Integration (Optional)

This project includes an optional AKS deployment using modular Bicep.

### Key Configuration
| Setting | Value |
|--------|-------|
| Cluster Type | Private |
| Network Plugin | Azure CNI (Overlay) |
| Dataplane | Cilium |
| Identity | System-assigned |
| Auth | Azure AD with Kubernetes RBAC |
| Node Pool Size | 1× Standard_B2s (autoscale off for lab use) |
| Deployment Trigger | `deployAks=true` |

### Example deployment including AKS

```powershell
az deployment sub create `
  --location eastus2 `
  --template-file .\main.bicep `
  --parameters deployAks=true
```

### Validate AKS Cluster

```powershell
az aks get-credentials `
  --resource-group rg-spoke-app `
  --name spoke-app-aks

kubectl get nodes
kubectl get pods -A
```

Validation confirms a private AKS control plane, working node connectivity, Cilium dataplane, and Azure AD RBAC integration.

## CI/CD Integration

This repository includes a GitHub Actions workflow that:

- Runs syntax validation on all Bicep templates
- Executes an automated Azure “what-if” deployment preview
- Authenticates securely using OpenID Connect (OIDC) federation with Azure

### 📘 CI/CD Validation Results

The latest **automated what-if deployment** was executed via GitHub Actions using OpenID Connect authentication.

✅ **Run #36** — [View Workflow Logs »](https://github.com/CamParent/iac-foundation/actions/runs/19154923538)  
📦 **Artifact:** [Download what-if-36.zip](https://github.com/CamParent/iac-foundation/actions/runs/19154923538#artifacts)

The `what-if` output confirms that the deployment would:
- **Create 7** new resources (custom Azure Policy Definitions + Assignments)
- **Modify 7** existing resources (resource group tagging, hub firewall, and Key Vault RBAC)
- **Ignore 20** unchanged resources (existing networking, routes, private endpoints, etc.)

**Highlights:**
- Enforces **Allowed Locations**, **Required Tags**, and **Standard SKU Public IP** Azure Policies  
- Adds consistent resource tagging across all resource groups  
- Updates Azure Firewall to **AlertAndDeny** mode with refined subnets  
- Enables **RBAC authorization** and **purge protection** in Key Vault  

> _This validation was fully automated through GitHub Actions, ensuring every infrastructure change is tested through Azure’s native “what-if” before deployment._

## Next Steps

- Integrate Azure Policy for compliance and governance
- Extend CI/CD pipelines for automated deployments
- Add Azure Bastion and Application Gateway + WAF for production readiness
- Connect Log Analytics + Azure Monitor for observability

Author

Cameron Parent — Network & Cloud Engineer • Azure Security Engineer • CISSP

LinkedIn: https://www.linkedin.com/in/camjosephparent/
