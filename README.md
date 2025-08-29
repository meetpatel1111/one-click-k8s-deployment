# Dynamic Reusable K8s Cluster with Networking + Apps + k8sGPT

Steps:

1. Customize terraform/terraform.tfvars
2. Build Node.js Docker image:
```bash
cd apps/nodejs-app
docker build -t <YOUR_DOCKER_USERNAME>/nodejs-app:latest .
docker push <YOUR_DOCKER_USERNAME>/nodejs-app:latest
```
3. Apply Terraform:
```bash
cd terraform
terraform init
terraform apply -auto-approve
```
4. Access:
- Node.js App: http://<node-public-lb-ip>:3000
- NGINX: http://<node-public-lb-ip>
- k8sGPT: http://<k8sgpt-lb-ip>


---

## 📘 Extended Project Overview

This repository is a **fully automated Kubernetes deployment solution** that combines:

- **Terraform** for provisioning cloud infrastructure (networking, cluster, nodes)
- **GitHub Actions** for CI/CD automation and parameterized workflows
- **Kubernetes** manifests and Helm for application deployment
- **Security Scans** integrated directly into the pipeline

### Key Workflows
- **One-Click K8s Deployment (`deploy-k8s.yml`)**
  - Provides parameterized infra + app deployments with granular control
- **Delete Applications (`delete-k8s-applications.yml`)**
  - Allows selective removal of apps from the cluster safely

### Supported Applications
- Node.js Web Application (served on LoadBalancer)
- NGINX Web Server
- k8sGPT (AI diagnostics using Google or OpenAI provider)

### Usage Flow
1. **Build and push app images** to DockerHub or your registry
2. **Run GitHub Action** with appropriate parameters (choose environment, action, provider, etc.)
3. **Access apps** via public LoadBalancer endpoints
4. **Optionally delete apps** via the controlled delete workflow

---

## 📊 Parameters and Variables

### Deployment Workflow Inputs
- **environment** → Target environment (`dev` / `test`)
- **action** → Terraform action (`apply`, `destroy`, `refresh`)
- **provider** → AI provider for k8sGPT (`google`, `openai`)
- **run_security_scan** → Boolean flag to run only security scans
- **run_terraform** → Boolean flag to enable infra provisioning
- **run_application_deployment** → Boolean flag to deploy Kubernetes apps

### Environment Variables & Secrets
- **DOCKER_USERNAME / DOCKER_PASSWORD** → For pulling/pushing container images
- **AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY** → For Terraform infra creation (AWS provider)

### Deletion Workflow Inputs
- **environment** → Target environment
- **dry_run** → Boolean, simulates deletions
- **apps_to_delete** → Comma-separated list of apps
- **confirm** → Must be `true` to allow actual deletion

---

## 📄 Extended Access Instructions

- **Node.js App**: `http://<lb-ip>/nodejs`
- **NGINX**: `http://<lb-ip>/nginx`
- **k8sGPT**: `http://<lb-ip>`

---

---

## 📑 Documentation Navigation

- [DOCUMENTATION.md](./Documents/DOCUMENTATION.md) – General documentation and explanations  
- [DEPLOYMENT.md](./Documents/DEPLOYMENT.md) – Deployment workflow and parameter guide  
- [WORKFLOW_DETAILED.md](./Documents/WORKFLOW_DETAILED.md) – Detailed workflow explanation (~400 lines)  
- [TERRAFORM_DETAILED.md](./Documents/TERRAFORM_DETAILED.md) – Terraform provisioning deep dive (~400 lines)  
- [KUBERNETES_DETAILED.md](./Documents/KUBERNETES_DETAILED.md) – Kubernetes application deployment (~400 lines)  
- [GITHUBACTIONS_DETAILED.md](./Documents/GITHUBACTIONS_DETAILED.md) – GitHub Actions automation (~400 lines)  
- [DELETE_WORKFLOW_DETAILED.md](./Documents/DELETE_WORKFLOW_DETAILED.md) – Safe deletion workflow (~400 lines)  
- [BEST_PRACTICES.md](./Documents/BEST_PRACTICES.md) – Security, scalability, and governance (~400 lines)  
- [HANDBOOK.md](./Documents/HANDBOOK.md) – Combined handbook (all docs in one)  

🔗 Extras:  
- [HANDBOOK.html](./Documents/HANDBOOK.html) – Web-friendly version  
- [HANDBOOK_QUICKSTART.pdf](./Documents/HANDBOOK_QUICKSTART.pdf) – Quickstart summary (2–3 pages)  
- [HANDBOOK_CHEATSHEET.pdf](./Documents/HANDBOOK_CHEATSHEET.pdf) – 1-page cheatsheet  
- [HANDBOOK_CHEATSHEET_GRAPHICAL.pdf](./Documents/HANDBOOK_CHEATSHEET_GRAPHICAL.pdf) – Visual cheatsheet with diagram  
- [HANDBOOK_FULL_PRESENTATION.pptx](./Documents/HANDBOOK_FULL_PRESENTATION.pptx) – Technical slide deck  
- [HANDBOOK_EXECUTIVE_PRESENTATION.pptx](./Documents/HANDBOOK_EXECUTIVE_PRESENTATION.pptx) – Executive-friendly deck  

---
