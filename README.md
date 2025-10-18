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

Scan the Docker image for vulnerabilities using Trivy:

```bash
# Basic scan
trivy image temperature-converter:latest

# High/Critical only (CI-friendly)
trivy image --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 temperature-converter:latest

# JSON report
trivy image -f json -o trivy-report.json temperature-converter:latest
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

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and test them
4. Commit your changes: `git commit -m 'Add amazing feature'`
5. Push to the branch: `git push origin feature/amazing-feature`
6. Open a Pull Request

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