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
