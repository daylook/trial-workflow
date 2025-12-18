#!/bin/bash
set -e

# ArgoCD Setup Script for EKS
# This script automates the installation of ArgoCD on your EKS cluster

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  ArgoCD Setup for EKS Cluster${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}Error: kubectl is not installed${NC}"
    exit 1
fi

if ! kubectl cluster-info &> /dev/null; then
    echo -e "${RED}Error: Cannot connect to Kubernetes cluster${NC}"
    exit 1
fi

echo -e "${GREEN}✓ kubectl is installed and cluster is accessible${NC}"

# Check for kustomize
if ! command -v kustomize &> /dev/null; then
    echo -e "${YELLOW}Warning: kustomize not found, will use kubectl apply -k${NC}"
fi

echo ""
echo -e "${YELLOW}Step 1: Installing ArgoCD...${NC}"
kubectl apply -k argocd/overlays/production/

echo ""
echo -e "${YELLOW}Step 2: Waiting for ArgoCD pods to be ready (this may take a few minutes)...${NC}"
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

echo -e "${GREEN}✓ ArgoCD is installed and running${NC}"

echo ""
echo -e "${YELLOW}Step 3: Getting ArgoCD admin password...${NC}"
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  ArgoCD Installation Complete!${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "${YELLOW}Access ArgoCD UI:${NC}"
echo ""
echo "Option 1 - Port Forward (Local Access):"
echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "  Then visit: https://localhost:8080"
echo ""
echo "Option 2 - LoadBalancer (if configured):"
echo "  $(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo 'Not configured')"
echo ""
echo "Option 3 - Ingress (if configured):"
echo "  Check argocd/overlays/production/ingress.yaml for the hostname"
echo ""
echo -e "${YELLOW}Login Credentials:${NC}"
echo "  Username: admin"
echo "  Password: ${ARGOCD_PASSWORD}"
echo ""
echo -e "${RED}⚠ IMPORTANT: Change the admin password after first login!${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Access the ArgoCD UI using one of the methods above"
echo "2. Change the admin password"
echo "3. Update image repository in application manifests:"
echo "   - argocd/applications/web-app-production.yaml"
echo "   - argocd/applications/web-app-staging.yaml"
echo "4. Apply the AppProject:"
echo "   kubectl apply -f argocd/applications/web-app-project.yaml"
echo "5. Deploy applications:"
echo "   kubectl apply -f argocd/applications/web-app-production.yaml"
echo ""
echo -e "${GREEN}For detailed instructions, see argocd/README.md${NC}"
echo ""
