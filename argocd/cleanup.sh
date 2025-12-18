#!/bin/bash
set -e

# ArgoCD Cleanup Script
# This script removes ArgoCD from your EKS cluster

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}======================================${NC}"
echo -e "${RED}  ArgoCD Cleanup Script${NC}"
echo -e "${RED}======================================${NC}"
echo ""
echo -e "${YELLOW}This will remove ArgoCD and all its resources from your cluster.${NC}"
echo -e "${RED}WARNING: This action cannot be undone!${NC}"
echo ""
read -p "Are you sure you want to continue? (yes/no): " -r
echo

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo -e "${YELLOW}Step 1: Deleting ArgoCD applications...${NC}"
if kubectl get applications -n argocd &> /dev/null; then
    kubectl delete -f argocd/applications/ --ignore-not-found=true
    echo -e "${GREEN}✓ Applications deleted${NC}"
else
    echo -e "${YELLOW}No applications found${NC}"
fi

echo ""
echo -e "${YELLOW}Step 2: Deleting ArgoCD installation...${NC}"
kubectl delete -k argocd/overlays/production/ --ignore-not-found=true

echo ""
echo -e "${YELLOW}Step 3: Waiting for resources to be deleted...${NC}"
sleep 5

echo ""
echo -e "${YELLOW}Step 4: Deleting ArgoCD namespace...${NC}"
kubectl delete namespace argocd --ignore-not-found=true

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  ArgoCD Cleanup Complete!${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "${GREEN}ArgoCD has been successfully removed from your cluster.${NC}"
echo ""
