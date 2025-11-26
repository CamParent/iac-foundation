# Microsoft Sentinel Queries — Azure IaC Foundation

This folder provides **Microsoft Sentinel / KQL detection logic** aligned with the
Azure IaC Foundation architecture.

It demonstrates **Security Monitoring-as-Code**—complementing the project’s
Infrastructure-as-Code and Policy-as-Code implementations.

These queries are mapped directly to deployed Azure resources (Firewall, AKS, Identity)
and reflect real-world SOC use cases for threat detection within a Zero Trust–aligned hybrid cloud architecture.

---

## Workspace

- **Log Analytics Workspace:** `law-sec-ops`
- **Resource Group:** `rg-shared-services`
- Once onboarded to **Microsoft Sentinel**, these queries may be used as:
  - **Hunting queries**, or
  - **Analytics rules** (for alerting)

---

## Prerequisites

Ensure the following:

- Microsoft Sentinel is **enabled** on `law-sec-ops`
- These data connectors are active:
  - Azure AD Sign-in Logs  
  - Azure Firewall  
  - Azure Kubernetes Service (AKS)  
  - Microsoft Defender for Cloud (containers)

---

## How to Use

1. Go to **Sentinel → Hunting → + New Query**
2. Paste a `.kql` file from `/sentinel/queries`
3. Run against the `law-sec-ops` workspace
4. Optionally save as:
   - A **Hunting query**, or
   - An **Analytics rule**
5. Future enhancement: integrate via **Sentinel Repositories** (GitHub sync)

---

## Layout

```text
sentinel/
├── README.md
└── queries/
    ├── identity-impossible-travel.kql
    ├── network-azurefirewall-high-volume-deny.kql
    └── aks-public-registry-pods.kql
```
- identity-* — identity / sign-in based detections (uses SigninLogs)
- network-* — network & Azure Firewall detections (uses AzureDiagnostics)
- aks-* — Kubernetes / container-focused detections (uses KubePodInventory, Defender for Containers data where available)

## Mapping to Project Components

| Query scope | Related IaC module(s) |
|--------|-------|
| Identity | security.bicep, Azure AD RBAC |
| Network | networking.bicep, firewall.bicep |
| AKS | aks.bicep |
| Telemetry | logging.bicep (law-sec-ops) |

These analytics rules extend the project from *Infrastructure & Policy-as-Code* into  
**Detection-as-Code (SOC-ready monitoring)**.

---

## Analytics Rule Templates

The following Scheduled Analytics Rule templates are included under:

sentinel/analytics/
├── identity-impossible-travel.json
├── network-high-volume-deny.json
└── aks-public-registry-pods.json

These align to the lab’s Zero Trust–oriented architecture and may be **imported into Microsoft Sentinel** via:

**Microsoft Sentinel → Analytics → + Create → Scheduled query rule → Import JSON**

| Rule Name | Detection Focus | Related IaC Component |
|-----------|------------------|----------------------|
| Identity – Possible Impossible Travel | Sign-in anomalies | Identity / RBAC |
| Network – High Volume Azure Firewall Deny | Firewall deny spikes | Hub Firewall |
| AKS – Pods Using Public Registry | Container supply-chain risk | AKS via IaC |

> Rules are disabled by default (`enabled: false`) to avoid accidental activation in lab environments. They may be enabled post-import.
