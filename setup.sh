#!/bin/bash
set -e

# Install ArgoCD CLI
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

# Create namespace for ArgoCD
kubectl create namespace argocd || true

# Install ArgoCD in Kubernetes
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "ArgoCD installed. Access with:"
echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "Then open https://localhost:8080"
echo "Get initial admin password with:"
echo "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"