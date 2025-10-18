<div align="center">

# 🌡️ Temperature Converter

**A modern, container-ready temperature conversion application (Celsius ↔ Fahrenheit) with web interface, REST API, and PostgreSQL persistence**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/node.js-24.x-green.svg)](https://nodejs.org/)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux-lightgrey)](https://github.com/nilsonsangy/temperature-converter)
[![Docker](https://img.shields.io/badge/docker-ready-blue.svg)](https://www.docker.com/)

*Convert temperatures easily, persist conversion history, and deploy anywhere with Docker or Kubernetes!*

</div>

---

## 🎓 Educational Purpose & Version Overview

**This application is specifically designed for educational purposes in container orchestration security training and workshops.**

### 📚 Learning Objectives

This project serves as a hands-on learning tool for:
- **Container Security**: Understanding vulnerabilities in containerized applications
- **Kubernetes Security**: Exploring security scanning, monitoring, and best practices
- **DevSecOps Workflows**: Integrating security tools (Snyk, Trivy, Falco) into CI/CD pipelines
- **Database Security**: Analyzing connection patterns and credential management

### 🔖 Version Differences

| Version | Database | Security Status | Use Case |
|---------|----------|-----------------|----------|
| **v1.0** | ❌ No database connection | ⚠️ Contains vulnerabilities | Basic security scanning demos |
| **v1.1** | ❌ No database connection | ✅ Vulnerabilities fixed | Secure baseline comparison |
| **v2.0** | ✅ PostgreSQL integration | ⚠️ Contains vulnerabilities | Advanced security scenarios |
| **v2.1** | ✅ PostgreSQL integration | ✅ Vulnerabilities fixed | Production-ready secure version |

### 🛡️ Security Training Scenarios

- **Vulnerability Detection**: Use scanning tools to identify security issues between versions
- **Remediation Practice**: Compare vulnerable (.0) vs secure (.1) versions
- **Database Security**: Analyze connection handling and credential management in v2.x
- **Runtime Monitoring**: Practice security monitoring with tools like Falco (in production environments)

### 🎯 Target Audience

- **DevOps Engineers** learning container security
- **Security Professionals** exploring Kubernetes security tools
- **Students** in cybersecurity and cloud computing courses
- **Workshop Participants** in container orchestration training

---

## 🚀 Features

- **🌡️ Temperature Conversion**: Convert between Celsius and Fahrenheit via web interface and REST API
- **💾 Persistent History**: PostgreSQL database stores the last 10 conversions
- **🎨 Modern UI**: Clean, responsive Bootstrap interface showing conversion history
- **🔄 REST API**: Programmatic access to conversion functions
- **🐳 Docker Ready**: Complete Docker Compose setup for development
- **☸️ Kubernetes Ready**: Production-ready Kubernetes manifests
- **📊 Real-time Display**: View latest conversions in a beautiful table format

## 📁 Project Structure

```
temperature-converter/
├── src/                     # Application source code
│   ├── server.js           # Express server with API endpoints
│   ├── convert.js          # Temperature conversion logic
│   ├── database.js         # PostgreSQL connection and queries
│   ├── views/index.ejs     # Web interface template
│   ├── config/system-life.js # Health and readiness endpoints
│   ├── test/convert.js     # Automated tests
│   ├── package.json        # Node.js dependencies
│   └── Dockerfile          # Container build configuration
├── k8s/                    # Kubernetes deployment manifests
│   └── deploy.yaml         # PostgreSQL and app deployment
├── docker-compose.yml      # Local development environment
├── init.sql               # Database initialization script
├── dev.sh                 # Development helper script
└── README.md              # This file
```

---

## 🏃‍♂️ Quick Start

### Option 1: Docker Compose (Recommended for Development)

1. **Start the application:**
   ```bash
   ./dev.sh start
   ```

2. **Access the application:**
   - Web Interface: http://localhost:8080
   - API: http://localhost:8080/celsius/25/fahrenheit

3. **Stop the application:**
   ```bash
   ./dev.sh stop
   ```

### Option 2: Kubernetes (Recommended for Production)

1. **Deploy to Kubernetes:**
   ```bash
   ./dev.sh k8s-deploy
   ```

2. **Check status:**
   ```bash
   ./dev.sh k8s-status
   ```

3. **Remove from Kubernetes:**
   ```bash
   ./dev.sh k8s-delete
   ```

---

## 🔄 Version Management for Security Training

### Switching Between Versions

```bash
# Access vulnerable versions (for training)
git checkout v1.0    # No database, with vulnerabilities
git checkout v2.0    # PostgreSQL, with vulnerabilities

# Access secure versions (for comparison)
git checkout v1.1    # No database, vulnerabilities fixed
git checkout v2.1    # PostgreSQL, vulnerabilities fixed

# Return to development branch
git checkout v2.0    # Current development version
```

### Training Workshop Flow

1. **Start with v1.0**: Basic vulnerability scanning demonstration
2. **Upgrade to v1.1**: Show remediation and security improvements
3. **Move to v2.0**: Introduce database security scenarios
4. **Finish with v2.1**: Demonstrate complete secure implementation

### Security Scanning Workflow

```bash
# Scan vulnerable version
git checkout v2.0
snyk test --severity-threshold=medium

# Compare with secure version  
git checkout v2.1
snyk test --severity-threshold=medium

# Analyze differences
git diff v2.0..v2.1 -- src/
```

---

## 🔧 Development Helper Script

The `dev.sh` script provides convenient commands for development:

```bash
./dev.sh start       # Start with Docker Compose
./dev.sh stop        # Stop Docker Compose
./dev.sh logs        # Show application logs
./dev.sh rebuild     # Rebuild and restart
./dev.sh k8s-deploy  # Deploy to Kubernetes
./dev.sh k8s-delete  # Remove from Kubernetes
./dev.sh k8s-status  # Show Kubernetes status
```

---

## 🌐 API Endpoints

### Conversion Endpoints
- `GET /celsius/{value}/fahrenheit` - Convert Celsius to Fahrenheit
- `GET /fahrenheit/{value}/celsius` - Convert Fahrenheit to Celsius

### Health Endpoints
- `GET /health` - Application health check
- `GET /ready` - Readiness probe
- `PUT /unhealth` - Simulate unhealthy state
- `PUT /unreadyfor/{seconds}` - Simulate not ready state

### Example API Usage
```bash
# Convert 25°C to Fahrenheit
curl http://localhost:8080/celsius/25/fahrenheit

# Convert 77°F to Celsius  
curl http://localhost:8080/fahrenheit/77/celsius
```

---

## 💾 Database Schema

The application uses PostgreSQL with the following schema:

```sql
CREATE TABLE conversions (
    id SERIAL PRIMARY KEY,
    original_value DECIMAL(10,2) NOT NULL,
    converted_value DECIMAL(10,2) NOT NULL,
    conversion_type VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🐳 Docker Setup

### Manual Docker Build
```bash
# Build the image
docker build -t temperature-converter:latest ./src

# Run with existing PostgreSQL
docker run -p 8080:8080 \
  -e DB_HOST=your-postgres-host \
  -e DB_USERNAME=user \
  -e DB_PASSWORD=password \
  -e DB_DATABASE=temperature_db \
  temperature-converter:latest
```

---

## ☸️ Kubernetes Configuration

The application is configured for Kubernetes with:

- **PostgreSQL Deployment**: Persistent database with health checks
- **App Deployment**: 3 replicas with resource limits
- **LoadBalancer Service**: External access to the application
- **Environment Variables**: Database connection configuration

### Resource Requirements
- **PostgreSQL**: 256Mi memory, 500m CPU
- **Application**: 256Mi memory, 500m CPU per replica

---

## 🧪 Running Tests

```bash
cd src
npm test
```

---

## 🔍 Security Scanning

### Snyk Security Scanning

Snyk provides comprehensive security scanning for dependencies, containers, Infrastructure as Code, and source code.

#### Prerequisites

```bash
# Install Snyk CLI
npm install -g snyk

# Authenticate with Snyk (requires browser)
snyk auth
```

#### Dependencies Vulnerability Scan

```bash
# Navigate to source directory and scan dependencies
cd src
snyk test

# Scan with specific severity threshold
snyk test --severity-threshold=medium

# Generate JSON report
snyk test --json > snyk-dependencies-report.json
```

#### Container Image Scan

```bash
# Scan the Docker image for vulnerabilities
snyk container test nilsonsangy/temperature-converter:v2.0

# Scan with severity threshold
snyk container test nilsonsangy/temperature-converter:v2.0 --severity-threshold=high

# Monitor container in Snyk dashboard
snyk container monitor nilsonsangy/temperature-converter:v2.0
```

#### Kubernetes Configuration Scan

```bash
# Scan Kubernetes manifests for security issues
snyk iac test k8s/deploy.yaml

# Scan with specific severity
snyk iac test k8s/deploy.yaml --severity-threshold=medium

# Generate detailed report
snyk iac test k8s/deploy.yaml --json > snyk-k8s-report.json
```

#### Source Code Security Scan

```bash
# Navigate to source directory and scan code
cd src
snyk code test

# Scan with severity threshold
snyk code test --severity-threshold=high
```

#### Comprehensive Security Workflow

```bash
# 1. Dependencies vulnerabilities
cd src && snyk test --severity-threshold=medium

# 2. Container image vulnerabilities  
snyk container test nilsonsangy/temperature-converter:v2.0

# 3. Kubernetes configuration security
snyk iac test k8s/deploy.yaml

# 4. Source code security analysis
cd src && snyk code test
```

### Falco Runtime Security Monitoring

Falco provides real-time threat detection and runtime security monitoring for Kubernetes environments.

#### Prerequisites

```bash
# Install Falco on Kubernetes cluster
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
helm install falco falcosecurity/falco --namespace falco --create-namespace

# Alternative: Install as DaemonSet
kubectl apply -f https://raw.githubusercontent.com/falcosecurity/deploy-kubernetes/main/kubernetes/falco-daemonset-config.yaml
```

#### Monitor Application Runtime Security

```bash
# View Falco logs for security events
kubectl logs -n falco -l app.kubernetes.io/name=falco -f

# Check for specific application alerts
kubectl logs -n falco -l app.kubernetes.io/name=falco | grep temperature-converter

# Monitor container anomalies
kubectl logs -n falco -l app.kubernetes.io/name=falco | grep "Anomalous container behavior"
```

#### Custom Falco Rules for Temperature Converter

Create `falco-rules.yaml` for application-specific monitoring:

```yaml
# Custom rules for temperature-converter security
- rule: Suspicious Network Activity in Temperature App
  desc: Detect unexpected network connections from temperature-converter
  condition: >
    (container.name startswith "temperature-converter" and
     (fd.type=ipv4 or fd.type=ipv6) and
     not fd.ip in (postgres_ips, allowed_external_ips))
  output: >
    Suspicious network connection from temperature-converter
    (container=%container.name pid=%proc.pid connection=%fd.name)
  priority: WARNING

- rule: Unauthorized File Access in Temperature App  
  desc: Detect unauthorized file system access
  condition: >
    (container.name startswith "temperature-converter" and
     open_read and not fd.name startswith "/app" and
     not fd.name startswith "/usr" and not fd.name startswith "/lib")
  output: >
    Unauthorized file access in temperature-converter
    (container=%container.name file=%fd.name pid=%proc.pid)
  priority: WARNING

- rule: Database Connection Anomaly
  desc: Detect unusual database connection patterns
  condition: >
    (container.name startswith "temperature-converter" and
     (fd.type=ipv4 and fd.sport!=5432 and proc.name=node))
  output: >
    Unusual database connection from temperature-converter
    (container=%container.name connection=%fd.name process=%proc.name)
  priority: NOTICE
```

#### Deploy Custom Rules

```bash
# Apply custom Falco rules
kubectl create configmap falco-rules --from-file=falco-rules.yaml -n falco
kubectl patch configmap falco -n falco --patch '{"data":{"falco.yaml":"rules_file:\n  - /etc/falco/falco_rules.yaml\n  - /etc/falco/falco-rules.yaml"}}'

# Restart Falco to load new rules
kubectl rollout restart daemonset/falco -n falco
```

#### Real-time Security Monitoring

```bash
# Stream security events in real-time
kubectl logs -n falco -l app.kubernetes.io/name=falco -f | grep -E "(temperature-converter|postgres|WARNING|CRITICAL)"

# Export security events to file
kubectl logs -n falco -l app.kubernetes.io/name=falco --since=1h > security-events.log

# Check for critical security violations
kubectl logs -n falco -l app.kubernetes.io/name=falco | grep CRITICAL
```

#### Easy Setup with Helper Script

Use the provided `falco-setup.sh` script for simplified Falco deployment:

```bash
# Complete Falco setup for Temperature Converter
./falco-setup.sh install       # Install Falco on cluster
./falco-setup.sh deploy-rules  # Deploy custom security rules
./falco-setup.sh monitor       # Start real-time monitoring

# Management commands
./falco-setup.sh status        # Check Falco status
./falco-setup.sh alerts        # View recent security alerts  
./falco-setup.sh test          # Test rules with simulated events
```

#### Integration with Alerting Systems

```bash
# Send Falco alerts to Slack (requires Falcosidekick)
helm install falcosidekick falcosecurity/falcosidekick \
  --set config.slack.webhookurl="YOUR_SLACK_WEBHOOK" \
  --namespace falco

# Send alerts to file for CI/CD integration
kubectl logs -n falco -l app.kubernetes.io/name=falco --since=5m | \
  grep -E "WARNING|CRITICAL" > /tmp/security-alerts.txt
```

#### Security Benefits for Temperature Converter

Falco enhances your project security by detecting:

1. **🌐 Network Anomalies**: Unauthorized connections from your app containers
2. **📁 File System Abuse**: Unexpected file access outside allowed directories  
3. **🔐 Privilege Escalation**: Attempts to gain unauthorized system access
4. **🗄️ Database Attacks**: Suspicious PostgreSQL access patterns
5. **⚡ Runtime Threats**: Malicious processes or container breakouts
6. **🔑 Secrets Exposure**: Unauthorized environment variable access

**Example Security Scenarios Detected:**
- Container trying to access `/etc/passwd` or other system files
- Unexpected network connections to external IPs
- Processes running with elevated privileges
- Database connections from non-application processes
- File modifications in sensitive directories

### Alternative: Trivy Security Scanner

For environments where Snyk is not available, use Trivy:

```bash
# Basic container scan
trivy image nilsonsangy/temperature-converter:v2.0

# High/Critical only (CI-friendly)
trivy image --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 nilsonsangy/temperature-converter:v2.0

# JSON report
trivy image -f json -o trivy-report.json nilsonsangy/temperature-converter:v2.0
```

---

## 🛠️ Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | `postgres` | PostgreSQL host |
| `DB_PORT` | `5432` | PostgreSQL port |
| `DB_USERNAME` | `user` | Database username |
| `DB_PASSWORD` | `password123` | Database password |
| `DB_DATABASE` | `temperature_db` | Database name |
| `NODE_ENV` | `development` | Node.js environment |
| `PORT` | `8080` | Application port |

---

## � Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   # Check what's using port 8080
   lsof -i :8080
   
   # Kill the process or use different port
   docker-compose down && docker-compose up -d
   ```

2. **Database connection failed**
   ```bash
   # Check PostgreSQL logs
   docker-compose logs postgres
   
   # Restart services
   docker-compose restart
   ```

3. **Application won't start**
   ```bash
   # View application logs
   docker-compose logs app
   
   # Rebuild if needed
   ./dev.sh rebuild
   ```

---

## 🤝 Contributing

**Educational Project Notice**: This application is designed for security training purposes. Contributions should maintain the educational value and security scenarios that make this project useful for learning container orchestration security.

### Contributing Guidelines

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and test them
4. Commit your changes: `git commit -m 'Add amazing feature'`
5. Push to the branch: `git push origin feature/amazing-feature`
6. Open a Pull Request

### Security Training Contributions

When contributing to this educational project, consider:
- **Vulnerability Examples**: Maintain intentional vulnerabilities in .0 versions for training
- **Security Fixes**: Implement proper fixes in .1 versions to demonstrate remediation
- **Documentation**: Include educational notes explaining security concepts
- **Testing Scenarios**: Add examples that help learners understand security tools

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 💸 Donations

If you find this project helpful and would like to support its development, consider making a donation. Your contribution helps keep this toolkit updated and motivates further improvements!

| ☕ Support this project | ☕ Apoie este projeto |
|------------------------|----------------------|
| If this project helps you or you think it's cool, consider supporting:<br>💳 [PayPal](https://www.paypal.com/donate/?business=7CC3CMJVYYHAC&no_recurring=0&currency_code=BRL)<br>![PayPal QR code](https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=https://www.paypal.com/donate/?business=7CC3CMJVYYHAC&no_recurring=0&currency_code=BRL) | Se este projeto te ajudar ou você achar legal, considere apoiar:<br>🇧🇷 Pix: `df92ab3c-11e2-4437-a66b-39308f794173`<br>![Pix QR code](https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=df92ab3c-11e2-4437-a66b-39308f794173) |

---

## 👨‍💻 Author

**Nilson Sangy**

- GitHub: [@nilsonsangy](https://github.com/nilsonsangy)
- Project Link: [https://github.com/nilsonsangy/temperature-converter](https://github.com/nilsonsangy/temperature-converter)