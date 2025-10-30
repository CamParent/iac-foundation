# IaC Foundation for Azure Infrastructure

This repository contains modular **Bicep** templates used to deploy a secure and scalable Azure environment.

---

## 📁 Repository Structure

iac-foundation/
├── main.bicep                           # Orchestrator (subscription scope)
├── modules/
│   ├── networking.bicep                 # Hub VNet + subnets (exports distilled)
│   ├── firewall.bicep                   # Azure Firewall + PIP
│   └── keyvault.bicep                   # Shared Key Vault/certs (optional to start)
├── exports/                             # Your auto-exported templates (reference only)
│   ├── rg-hub-networking.bicep
│   ├── rg-shared-services.bicep
│   └── rg-spoke-app.bicep
├── envs/
│   └── dev.bicepparam                   # Per-environment values
└── scripts/

---

## 🚀 Getting Started

### Prerequisites
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- [Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)

### Login and Select Subscription
```bash
az login --tenant 8b36a591-80dc-44e6-aefc-29e07f135ebd
az account set --subscription 95f5b230-2ac0-46e4-9e78-213a57b19bda
```

---

## 🧱 Next Steps
- Modularize existing Bicep templates.
- Add parameter files for each environment (dev, test, prod).
- Implement CI/CD with GitHub Actions for automated deployments.