#!/bin/bash

# Falco Security Monitoring Setup for Temperature Converter
# This script installs and configures Falco for runtime security monitoring

echo "🦅 Setting up Falco Runtime Security for Temperature Converter..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is required but not installed."
    exit 1
fi

# Check if helm is available
if ! command -v helm &> /dev/null; then
    echo "❌ Helm is required but not installed."
    echo "📖 Install Helm: https://helm.sh/docs/intro/install/"
    exit 1
fi

case "$1" in
    "install")
        echo "📦 Installing Falco..."
        
        # Add Falco Helm repository
        helm repo add falcosecurity https://falcosecurity.github.io/charts
        helm repo update
        
        # Create falco namespace
        kubectl create namespace falco --dry-run=client -o yaml | kubectl apply -f -
        
        # Install Falco with basic configuration (compatible with latest version)
        # - gRPC API: Enable external integrations (dashboards, alerts)
        # - Log Level: Control verbosity (DEBUG/INFO/WARN/ERROR)
        helm upgrade --install falco falcosecurity/falco \
            --namespace falco \
            --set falco.grpc.enabled=true \
            --set falco.grpcOutput.enabled=true
            
        echo "✅ Falco installed successfully!"
        ;;
        
    "deploy-rules")
        echo "📋 Deploying custom rules for Temperature Converter..."
        
        # Create ConfigMap with custom rules
        kubectl create configmap temperature-converter-falco-rules \
            --from-file=falco-rules.yaml \
            --namespace falco \
            --dry-run=client -o yaml | kubectl apply -f -
            
        # Patch Falco configuration to include custom rules
        kubectl patch configmap falco -n falco --type merge -p '{
            "data": {
                "falco.yaml": "rules_file:\n  - /etc/falco/falco_rules.yaml\n  - /etc/falco/falco_rules.local.yaml\n  - /etc/falco/temperature-converter-rules.yaml\nload_plugins: []\nwebserver:\n  enabled: true\n  listen_port: 8765\n  k8s_healthz_endpoint: /healthz\n  ssl_enabled: false\ngrpc:\n  enabled: true\n  bind_address: 0.0.0.0\n  listen_port: 5060\n  timeout: 90s\ngrpc_output:\n  enabled: true\nfile_output:\n  enabled: true\n  keep_alive: false\n  filename: /var/log/falco.log\nlog_level: INFO"
            }
        }'
        
        # Mount custom rules in Falco DaemonSet
        kubectl patch daemonset falco -n falco --type json -p='[
            {
                "op": "add",
                "path": "/spec/template/spec/volumes/-",
                "value": {
                    "name": "temperature-converter-rules",
                    "configMap": {
                        "name": "temperature-converter-falco-rules"
                    }
                }
            },
            {
                "op": "add", 
                "path": "/spec/template/spec/containers/0/volumeMounts/-",
                "value": {
                    "name": "temperature-converter-rules",
                    "mountPath": "/etc/falco/temperature-converter-rules.yaml",
                    "subPath": "falco-rules.yaml"
                }
            }
        ]'
        
        # Restart Falco to load new rules
        kubectl rollout restart daemonset/falco -n falco
        kubectl rollout status daemonset/falco -n falco --timeout=60s
        
        echo "✅ Custom rules deployed successfully!"
        ;;
        
    "monitor")
        echo "👀 Starting real-time security monitoring..."
        echo "Press Ctrl+C to stop monitoring"
        echo ""
        
        kubectl logs -n falco -l app.kubernetes.io/name=falco -f | \
        grep -E "(temperature-converter|postgres|WARNING|ERROR|CRITICAL)" --color=always
        ;;
        
    "alerts")
        echo "🚨 Checking recent security alerts..."
        
        kubectl logs -n falco -l app.kubernetes.io/name=falco --since=1h | \
        grep -E "(WARNING|ERROR|CRITICAL)" | \
        while read line; do
            echo "🚨 $line"
        done
        ;;
        
    "status")
        echo "📊 Falco Status:"
        echo ""
        
        echo "🔍 Falco Pods:"
        kubectl get pods -n falco -l app.kubernetes.io/name=falco
        echo ""
        
        echo "📋 Custom Rules:"
        kubectl get configmap -n falco | grep temperature-converter
        echo ""
        
        echo "📈 Recent Activity (last 10 minutes):"
        kubectl logs -n falco -l app.kubernetes.io/name=falco --since=10m | \
        grep -E "(temperature-converter|postgres)" | tail -5
        ;;
        
    "uninstall")
        echo "🗑️ Uninstalling Falco..."
        
        helm uninstall falco -n falco
        kubectl delete namespace falco
        
        echo "✅ Falco uninstalled successfully!"
        ;;
        
    "test")
        echo "🧪 Testing Falco rules with simulated events..."
        
        # Deploy a test pod that will trigger some rules
        kubectl run falco-test --image=busybox --restart=Never --rm -i --tty -- sh -c '
            echo "Testing file access...";
            cat /etc/passwd > /dev/null;
            echo "Testing network activity...";
            nc -z google.com 80 2>/dev/null || echo "Network test completed";
            echo "Test completed - check Falco logs for alerts"
        ' 2>/dev/null || true
        
        echo ""
        echo "🔍 Check for alerts in the last minute:"
        sleep 5
        kubectl logs -n falco -l app.kubernetes.io/name=falco --since=1m | \
        grep -E "(falco-test|WARNING|ERROR)" || echo "No alerts found"
        ;;
        
    *)
        echo "🦅 Falco Security Monitoring for Temperature Converter"
        echo ""
        echo "Available commands:"
        echo "  install       - Install Falco on Kubernetes cluster"
        echo "  deploy-rules  - Deploy custom security rules for Temperature Converter"
        echo "  monitor       - Start real-time security monitoring"
        echo "  alerts        - Check recent security alerts"
        echo "  status        - Show Falco status and recent activity"
        echo "  test          - Test Falco rules with simulated events"
        echo "  uninstall     - Remove Falco from cluster"
        echo ""
        echo "Usage: ./falco-setup.sh [command]"
        echo ""
        echo "Complete setup:"
        echo "  1. ./falco-setup.sh install"
        echo "  2. ./falco-setup.sh deploy-rules"  
        echo "  3. ./falco-setup.sh monitor"
        ;;
esac