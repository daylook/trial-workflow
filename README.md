# trial-workflow
A trial workflow to deploy a java based application in K8s clsuter with helm charts.

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
