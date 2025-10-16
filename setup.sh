#!/bin/bash
set -e

# create k3d cluster
# k3d cluster create homelab \
#  -p "8080:80@loadbalancer" \
#  -p "8443:443@loadbalancer" \
#  --agents 2 \
#  --servers 1 \
#  --k3s-arg "--disable=traefik@server:0" 
#

# Install ArgoCD CLI
if command -v argocd &> /dev/null
then
    echo "ArgoCD CLI is already installed"
else 
    echo "Installing ArgoCD CLI"
    if curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64; then
        sudo mv argocd /usr/local/bin/argocd
        sudo chmod +x /usr/local/bin/argocd
    else
        echo "Failed to download ArgoCD CLI" >&2
        exit 1
    fi
fi


# Create namespace for ArgoCD
kubectl create namespace argocd || true

# Install ArgoCD in Kubernetes
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "ArgoCD installed. Access with:"
echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "Then open https://localhost:8080"
echo "Get initial admin password with:"
echo "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"

# To enable kustomize in argocd you must add the following under the argocd-cm configmap:
# kustomize.buildOptions: --enable-helm --load-restrictor=LoadRestrictionsNone