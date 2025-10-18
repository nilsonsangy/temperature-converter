#!/bin/bash

# Development Scripts for Temperature Converter

case "$1" in
    "start")
        echo "🚀 Starting Temperature Converter with Docker Compose..."
        docker compose up -d
        echo "✅ Application started! Access http://localhost:8080"
        ;;
    "stop")
        echo "🛑 Stopping Temperature Converter..."
        docker compose down
        echo "✅ Application stopped!"
        ;;
    "logs")
        echo "📋 Showing application logs..."
        docker compose logs -f app
        ;;
    "status")
        echo "📊 Checking application status..."
        docker compose ps
        echo ""
        echo "Testing API endpoint:"
        curl -s http://localhost:8080/celsius/0/fahrenheit || echo "❌ Application not responding"
        ;;
    "db")
        echo "🗄️ Connecting to PostgreSQL database..."
        docker compose exec postgres psql -U user -d temperature_db
        ;;
    "test")
        echo "🧪 Running tests..."
        if docker compose exec app npm test 2>/dev/null; then
            echo "✅ All tests passed!"
        else
            echo "❌ Tests failed or not available"
        fi
        ;;
    "rebuild")
        echo "🔨 Rebuilding application..."
        docker compose down
        docker compose build --no-cache
        docker compose up -d
        echo "✅ Application rebuilt and started!"
        ;;
    "k8s-deploy")
        echo "☸️ Deploying to Kubernetes..."
        kubectl apply -f k8s/deploy.yaml
        echo "✅ Deployed to Kubernetes!"
        echo "Run 'kubectl get services' to see the service URL"
        ;;
    "k8s-delete")
        echo "🗑️ Removing from Kubernetes..."
        kubectl delete -f k8s/deploy.yaml
        echo "✅ Removed from Kubernetes!"
        ;;
    "k8s-status")
        echo "📊 Kubernetes status:"
        echo "Pods:"
        kubectl get pods -l app=temperature-converter
        kubectl get pods -l app=postgres
        echo ""
        echo "Services:"
        kubectl get services
        ;;
    *)
        echo "🌡️ Temperature Converter Development Helper"
        echo ""
        echo "Available commands:"
        echo "  start       - Start with Docker Compose"
        echo "  stop        - Stop Docker Compose"
        echo "  status      - Check application status"
        echo "  logs        - Show application logs"
        echo "  db          - Connect to PostgreSQL database"
        echo "  test        - Run application tests"
        echo "  rebuild     - Rebuild and restart"
        echo "  k8s-deploy  - Deploy to Kubernetes"
        echo "  k8s-delete  - Remove from Kubernetes"
        echo "  k8s-status  - Show Kubernetes status"
        echo ""
        echo "Usage: ./dev.sh [command]"
        ;;
esac