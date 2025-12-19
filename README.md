# trial-workflow

Workflows

1. ci-build-java.yml (Main Pipeline) : Complete CI/CD pipeline for Java application

2. reusable-deploy.yml (Direct Deployment): Direct deployment to EKS using Helm

3. reusable-gitops-update.yml (GitOps Update): Update Helm values and ArgoCD manifests (GitOps approach)


Actions

1. java-build-test: Build JAR and run tests with Gradle

2. docker-build-push-hub: Build and push Docker images to Docker Hub

3. docker-build-push-ecr: Build and push Docker images to Amazon ECR

4. eks-helm-deploy: Deploy applications to EKS using Helm

5. configure-aws-credentials: Configure AWS credentials using OIDC


Deployment Patterns

1. Direct Deployment (Fast): `docker-ecr → deploy`

2. GitOps Deployment (Recommended) : `docker-ecr → update-helm-chart → ArgoCD auto-sync`

## Infrastructure Local Development

```bash
# Initialize
cd terraform/environments/prod
terraform init

# Select Workspace
terraform workspace select production
# Or create
terraform workspace new production

# Format & Validate
terraform fmt -recursive ../../
terraform validate

# Plan & Apply
terraform plan
terraform apply

#Option 3: Terraform Destroy (Local)
cd terraform/environments/prod
terraform workspace select production
terraform plan -destroy  # Preview
terraform destroy        # Execute
```

## Accessing the EKS Cluster

```bash
# List clusters
aws eks list-clusters --region eu-central-1

# Or with eksctl
eksctl --region eu-central-1 get clusters

# Update kubeconfig
aws eks --region eu-central-1 update-kubeconfig --name eks-cluster

# Verify access
kubectl get nodes
```

## Test Locally

```bash
# Test Java build and tests
cd web-app
./gradlew clean build test

# Verify JAR was created
ls -lh build/libs/

# Test Docker build
docker build -t web-app:test .

# Run container
docker run web-app:test
```
