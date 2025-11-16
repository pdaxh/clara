#!/bin/bash
# Script to create a Sealed Secret for Clara's Google API key
# This encrypts the secret so it can be safely committed to Git

set -e

echo "🔐 Creating Sealed Secret for Clara..."

# Check if kubeseal is installed
if ! command -v kubeseal &> /dev/null; then
    echo "❌ kubeseal not found. Install with: brew install kubeseal"
    exit 1
fi

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot access Kubernetes cluster. Please ensure kubectl is configured."
    exit 1
fi

# Check if sealed-secrets controller is running
if ! kubectl get deployment -n kube-system sealed-secrets-controller &> /dev/null; then
    echo "⚠️  Sealed Secrets controller not found. Installing..."
    kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.24.0/controller.yaml
    echo "⏳ Waiting for controller to be ready..."
    kubectl wait --for=condition=available --timeout=120s deployment/sealed-secrets-controller -n kube-system
fi

# Prompt for API key if not provided as argument
if [ -z "$1" ]; then
    echo "Enter your Google ADK API key:"
    read -s GOOGLE_API_KEY
else
    GOOGLE_API_KEY="$1"
fi

# Create temporary secret file
TEMP_SECRET="/tmp/clara-secret-temp.yaml"
cat > "$TEMP_SECRET" << EOF
apiVersion: v1
kind: Secret
metadata:
  name: clara-secrets
  namespace: clara
  labels:
    app: clara
type: Opaque
stringData:
  google-api-key: "${GOOGLE_API_KEY}"
EOF

# Seal the secret
echo "🔒 Sealing secret..."
kubeseal --format yaml --namespace clara < "$TEMP_SECRET" > secret-sealed.yaml

# Clean up temporary file
rm "$TEMP_SECRET"

echo "✅ Sealed secret created: k8s/secret-sealed.yaml"
echo "📝 You can now safely commit this file to Git"
echo ""
echo "To apply the sealed secret:"
echo "  kubectl apply -f k8s/secret-sealed.yaml"

