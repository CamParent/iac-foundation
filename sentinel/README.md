# Microsoft Sentinel Integration

This directory contains **modular Microsoft Sentinel content** for a production-grade Azure security monitoring environment, including:

- 🔍 Custom **Analytics Rules** (KQL-based alerting)
- 📊 **Workbooks** for visualization and dashboards
- 🔄 **GitHub Actions automation** for rule deployment and tagging validation
- 🧪 A **Log Ingestion Lab** to simulate Windows Security Event ingestion using Azure Monitor Agent and Data Collection Rules (DCR)

Designed to support secure-by-default detection engineering and end-to-end visibility.

---

## 🔧 Sentinel Automation with GitHub Actions

Sentinel rules under `sentinel/analytics/` are automatically deployed using a dedicated GitHub Actions workflow.

### Features

- ✅ Validates all `.json` rule files for proper syntax
- 🏷️ Enforces presence of required tags (Environment, Owner, Project, DeployedBy)
- 🚀 Deploys each rule to Sentinel via REST API with `az rest`
- 🔐 Uses [OIDC-based login](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-cli%2Clinux) (no stored secrets)

### Required Tags Example

```json
"tags": {
  "Environment": "Dev",
  "Owner": "security-team@example.com",
  "Project": "iac-foundation",
  "DeployedBy": "GitHubActions"
}
```
### Trigger Conditions
  - Any push to sentinel/analytics/**
  - Manual runs via the GitHub UI (workflow_dispatch)

📂 See .github/workflows/sentinel-rule-deploy.yaml

---

## 🧪 Log Ingestion Lab
A hands-on lab for simulating ingestion of **Windows Security Events** into Sentinel using:
  - ⚙️ Azure Monitor Agent (AMA)
  - 📜 Data Collection Rule (DCR)
  - 📡 Log Analytics Workspace: law-sec-ops
  - 🧠 Microsoft Sentinel

### Components

| Components | Description |
|--------|-------|
| sentinelvm01 | Windows VM (test host) |
| sentinel-dcr | Data Collection Rule (ingests Security!* logs) |
| AMA Extension | Installed on VM and bound to DCR |
| law-sec-ops | Log Analytics Workspace (feeds Sentinel) |

### Deployment

```powershell
cd .\sentinel\ingest-lab\
.\deploy.ps1
```

Simulate Events: 

```powershell
.\simulate-events.ps1
```

### Confirm Ingestion in Sentinel

```kusto
SecurityEvent
| where EventID == 4625
| sort by TimeGenerated desc
```

Allow ~5 minutes for ingestion.

---

## 📊 Workbooks (Custom Dashboards)

The sentinel/workbooks/ directory holds custom Sentinel workbooks (JSON-formatted ARM templates) for dashboard visualization.

To deploy:

```bash
az resource create \
  --resource-group rg-shared-services \
  --resource-type Microsoft.Insights/workbooks \
  --name "<workbook-name>" \
  --properties @"sentinel/workbooks/<workbook>.json" \
  --location eastus2
```

---

📁 Directory Layout

```text
sentinel/
├── analytics/        # KQL-based analytics rules (JSON)
├── workbooks/        # Dashboard visualizations (ARM templates)
├── ingest-lab/       # Log ingestion simulation (scripts + templates)
│   ├── deploy.ps1
│   ├── simulate-events.ps1
│   └── patched-dcr.json
└── README.md         # You are here
```

---

## ✅ Next Steps
  - Add custom workbooks and link to shared workspace
  - Tune analytics rules with incident enrichment
  - Implement alert grouping and MITRE coverage tracking
  - Integrate threat intelligence (TI) providers

---

## 🧠 Learn More
- https://learn.microsoft.com/en-us/azure/sentinel/
- https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/