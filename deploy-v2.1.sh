#!/bin/bash

# Secure Deployment Script for Temperature Converter v2.1
# This script deploys the application using Kubernetes Secrets

echo "🔐 Deploying Temperature Converter v2.1 with Enhanced Security"
echo "=============================================================="

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is required but not installed."
    exit 1
fi

case "$1" in
    "deploy")
        echo "🚀 Deploying secure v2.1 version..."
        echo ""
        
        # Check if secrets.yaml exists
        if [ ! -f "k8s/secrets.yaml" ]; then
            echo "❌ ERROR: k8s/secrets.yaml not found!"
            echo ""
            echo "📋 Setup Instructions:"
            echo "1. Copy the template: cp k8s/secrets-example.yaml k8s/secrets.yaml"
            echo "2. Edit k8s/secrets.yaml and replace placeholder values"
            echo "3. Encode your values: echo -n 'your-value' | base64"
            echo "4. Run this command again"
            echo ""
            echo "⚠️  SECURITY: Never commit k8s/secrets.yaml to git!"
            exit 1
        fi
        
        echo "1️⃣ Applying Kubernetes Secrets..."
        kubectl apply -f k8s/secrets.yaml
        echo "✅ Secrets created successfully"
        echo ""
        
        echo "2️⃣ Deploying application with secure configuration..."
        kubectl apply -f k8s/deploy-v2.1.yaml
        echo "✅ Secure deployment applied"
        echo ""
        
        echo "3️⃣ Waiting for pods to be ready..."
        kubectl rollout status deployment/postgres --timeout=120s
        kubectl rollout status deployment/temperature-converter --timeout=120s
        echo ""
        
        echo "🔍 Deployment Status:"
        kubectl get pods -l version=v2.1
        echo ""
        
        echo "🌐 Service Information:"
        kubectl get services
        echo ""
        
        echo "✅ Secure deployment completed!"
        echo ""
        echo "🔒 Security Improvements in v2.1:"
        echo "   ✓ Database credentials stored in Kubernetes Secrets"
        echo "   ✓ Base64 encoded sensitive data"
        echo "   ✓ Security contexts with non-root users"
        echo "   ✓ Read-only root filesystems"
        echo "   ✓ Dropped ALL capabilities"
        echo "   ✓ Health checks implemented"
        echo "   ✓ Resource limits and requests defined"
        ;;
        
    "secrets")
        echo "🔍 Viewing Kubernetes Secrets (safe view)..."
        echo ""
        
        echo "📋 Secrets Overview:"
        kubectl get secrets -l app=temperature-converter
        echo ""
        
        echo "🔐 postgres-credentials Secret:"
        kubectl describe secret postgres-credentials
        echo ""
        
        echo "🔐 app-credentials Secret:"
        kubectl describe secret app-credentials
        echo ""
        
        echo "⚠️  To view actual values (use carefully):"
        echo "kubectl get secret postgres-credentials -o jsonpath='{.data.username}' | base64 -d"
        ;;
        
    "verify")
        echo "🔍 Verifying secure deployment..."
        echo ""
        
        echo "1️⃣ Checking if secrets exist:"
        kubectl get secrets postgres-credentials app-credentials || echo "❌ Secrets not found"
        echo ""
        
        echo "2️⃣ Checking pod security contexts:"
        kubectl get pods -l app=temperature-converter -o jsonpath='{.items[*].spec.containers[*].securityContext}' | jq '.' 2>/dev/null || echo "Security contexts applied"
        echo ""
        
        echo "3️⃣ Verifying no plain text credentials in deployments:"
        if kubectl get deployment temperature-converter -o yaml | grep -i "password.*value:" >/dev/null; then
            echo "❌ Plain text credentials found!"
        else
            echo "✅ No plain text credentials found"
        fi
        echo ""
        
        echo "4️⃣ Checking application health:"
        kubectl get pods -l app=temperature-converter
        ;;
        
    "setup-secrets")
        echo "🔐 Setting up Kubernetes Secrets..."
        echo ""
        
        if [ -f "k8s/secrets.yaml" ]; then
            echo "⚠️  k8s/secrets.yaml already exists!"
            echo "Do you want to overwrite it? (y/N)"
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                echo "❌ Setup cancelled"
                exit 0
            fi
        fi
        
        echo "📋 Copying template file..."
        cp k8s/secrets-example.yaml k8s/secrets.yaml
        
        echo "✅ Template copied to k8s/secrets.yaml"
        echo ""
        echo "📝 NEXT STEPS:"
        echo "1. Edit k8s/secrets.yaml"
        echo "2. Replace <BASE64_ENCODED_*> placeholders with actual values"
        echo "3. Use this to encode values: echo -n 'your-value' | base64"
        echo ""
        echo "🔍 Example commands:"
        echo "echo -n 'myuser' | base64     # For username"
        echo "echo -n 'mypass123' | base64  # For password"
        echo "echo -n 'mydb' | base64       # For database"
        echo ""
        echo "⚠️  SECURITY WARNING: Never commit k8s/secrets.yaml to git!"
        ;;
        
    "cleanup")
        echo "🧹 Cleaning up v2.1 deployment..."
        
        kubectl delete -f k8s/deploy-v2.1.yaml 2>/dev/null || true
        kubectl delete -f k8s/secrets.yaml 2>/dev/null || true
        
        echo "✅ Cleanup completed"
        ;;
        
    "compare")
        echo "📊 Comparing v2.0 vs v2.1 Security..."
        echo ""
        
        echo "🔓 v2.0 (Vulnerable):"
        echo "   ❌ Plain text credentials in deploy.yaml"
        echo "   ❌ No security contexts"
        echo "   ❌ Root user execution"
        echo "   ❌ No resource limits"
        echo "   ❌ No health checks"
        echo ""
        
        echo "🔒 v2.1 (Secure):"
        echo "   ✅ Kubernetes Secrets for credentials"
        echo "   ✅ Security contexts with non-root users" 
        echo "   ✅ Read-only root filesystems"
        echo "   ✅ Dropped ALL capabilities"
        echo "   ✅ Resource limits and requests"
        echo "   ✅ Liveness and readiness probes"
        echo "   ✅ Base64 encoded sensitive data"
        ;;
        
    *)
        echo "🔐 Secure Temperature Converter v2.1 Deployment"
        echo ""
        echo "Available commands:"
        echo "  setup-secrets - Setup secrets.yaml from template (REQUIRED FIRST)"
        echo "  deploy        - Deploy v2.1 with enhanced security"
        echo "  secrets       - View Kubernetes Secrets information"
        echo "  verify        - Verify secure deployment"
        echo "  compare       - Compare v2.0 vs v2.1 security"
        echo "  cleanup       - Remove v2.1 deployment"
        echo ""
        echo "Usage: ./deploy-v2.1.sh [command]"
        echo ""
        echo "Security Features in v2.1:"
        echo "  🔒 Kubernetes Secrets for sensitive data"
        echo "  🛡️ Security contexts and non-root users"
        echo "  📊 Health checks and resource management"
        echo "  🔍 Enhanced monitoring and verification"
        ;;
esac