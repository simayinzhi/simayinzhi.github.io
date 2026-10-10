---
title: "Postmortem: INC-20261118 Core Merchant System Outage (P1)"
---

# Incident Postmortem: INC-20261118

## 1. Incident Overview
* **Incident ID**: INC-20261118-MERCHANT-P1
* **Severity Level**: **P1 (Critical Platform Blackout)**
* **Impact Duration**: 15 minutes (14:15:22 – 14:30:18 CST)
* **Impacted Service**: `merchant-core-service`
* **Business Impact**: Total drop of core merchant order ingestion to **zero QPS** across all regions.
* **Incident Owner**: Albert (Merchant Core Pod Lead)
* **Contributing Engineers**: Vincent (API Gateway Pod), Victor (Engineering Lead), Andrew (Head of Operations)

---

## 2. Incident Timeline
* **Yesterday 17:00:00** – Albert deploys the documentation cleanup branch to the Staging environment. All automated smoke tests pass 100% against the stable gateway client snapshot.
* **Yesterday 23:55:00** – Vincent refactors `api-gateway-client` with a breaking method signature change and publishes `1.2.0-SNAPSHOT` to the internal Maven repository without downstream compatibility testing.
* **14:10:00** – Albert reviews yesterday's green staging verification and triggers a production release of `merchant-core-service`. Because the legacy pipeline rebuilds from source (`mvn clean package`), it dynamically pulls Vincent's midnight SNAPSHOT. Assuming zero risk for documentation changes, Albert bypasses the 1-node canary gate.
* **14:15:22** – All 40 application instances fail Spring container boot (`NoSuchMethodError` in `api-gateway-client`). Edge gateway returns 502/504 errors. Merchant order intake drops to **0 QPS**. High-priority P0/P1 emergency siren triggers.
* **14:16:30** – Albert triggers an immediate build rollback via the legacy release console.
* **14:18:45** – Rollback build completes from source, but the rollback instances **also crash on startup** with the identical error because the build dynamically re-fetches Vincent's poisoned SNAPSHOT.
* **14:20:10** – Emergency war room bridge convenes. Phil directs stack trace analysis. Victor identifies `NoSuchMethodError` during Spring bean wiring of the API Gateway client.
* **14:22:30** – Vincent confirms `api-gateway-client:1.2.0-SNAPSHOT` was updated on the internal Maven repository late the previous night without staging verification.
* **14:24:00** – Andrew confirms the legacy release system executes a full Maven dependency resolution on every release and rollback build, repeatedly pulling the broken `SNAPSHOT` artifact.
* **14:25:15** – Phil directs Vincent to revert the breaking commit in Git and publish a verified `1.2.0-SNAPSHOT` artifact.
* **14:27:50** – New client artifact uploaded. `merchant-core-service` rebuilt and rolling restart executed.
* **14:30:18** – All 40 application pods report healthy JVM status. Edge gateway errors drop to zero. Order volume fully restored to 4,500 QPS.

---

## 3. Root Cause Analysis (5 Whys)
1. **Why did the Merchant Service crash on startup?**
   The Spring `ApplicationContext` threw `NoSuchMethodError` when initializing the `GatewayRoutingFilter` bean from the `api-gateway-client` library.
2. **Why was the method missing in the client library?**
   Vincent altered the internal client method signature the night before and published `api-gateway-client:1.2.0-SNAPSHOT` to the internal Maven repository without testing downstream compatibility.
3. **Why did Albert's comment-only release pull the broken library?**
   The `pom.xml` of `merchant-core-service` declared a dynamic `SNAPSHOT` dependency. Maven re-resolved and downloaded the newest remote SNAPSHOT during build execution.
4. **Why did the rollback fail to recover the service?**
   The legacy release pipeline lacked **immutable artifact caching**. Triggering a "rollback" simply executed a fresh Maven build against the previous Git commit, re-fetching the breaking SNAPSHOT dependency from the Maven repository.
5. **Why did the failure cause a company-wide P1 blackout?**
   Albert bypassed the mandatory **1-node canary observation gate**, deploying to 100% of the production cluster simultaneously because he believed documentation-only changes carried zero operational risk and was rushing to leave for his wedding anniversary.

---

## 4. Incident Attribution & Governance Principle
* **Designated Incident Owner**: **Albert**
* **Attribution Rationale**:
  * In distributed systems, platform infrastructure, shared repositories, and upstream libraries will inevitably encounter defects and breaking changes.
  * Systemic stability relies on the **deterministic gate of the deployer**. Had the deployer observed the first canary node for 3–5 minutes as required by standard operational protocol, the startup crash would have been contained to a single offline node with **zero business impact**.
  * Attribution is assigned to reinforce the operational gate, establishing that **every deployer bears absolute accountability for verifying their release before opening traffic gates.**

---

## 5. Corrective & Preventative Action Items

| #          | Action Item                                                                                                                                                                                                                                                                               | Owner                      | Target Completion | Status      |
| :--------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------- | :---------------- | :---------- |
| **ACT-01** | **Immutable Artifact Retention in Release Platform**: Upgrade the CI/CD release system to store previous stable build artifacts locally on node disks and S3 storage, ensuring rollbacks bypass Maven builds and dependency resolution entirely. Andrew to audit and report storage cost. | Andrew (Operations)        | Sprint 24         | In Progress |
| **ACT-02** | **Company-Wide Production SNAPSHOT Ban**: Implement an automated POM dependency linter in the release pipeline. Any build containing dynamic `-SNAPSHOT` dependencies must be hard-blocked from deploying to staging and production environments.                                         | Vincent / Sky (Middleware) | Sprint 23         | In Progress |
| **ACT-03** | **Institutionalization of the Official *Release Manual***: Publish standard operating procedures requiring every engineer to observe the first canary node's health and telemetry for a minimum of 5 minutes before advancing traffic, regardless of change size.                         | Phil (Stability Group)     | Immediate         | Done        |
