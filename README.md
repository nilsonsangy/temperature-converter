<div align="center">

# 🌡️ Temperature Converter

**A simple and container-ready temperature conversion toolkit (Celsius ↔ Fahrenheit) with web and REST API**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/node.js-18.x-green.svg)](https://nodejs.org/)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux-lightgrey)](https://github.com/nilsonsangy/temperature-converter)
[![Docker](https://img.shields.io/badge/docker-ready-blue.svg)](https://www.docker.com/)

*Convert temperatures easily, run anywhere, and deploy with Docker or Kubernetes!*

</div>

---

## About the Project

This project is a temperature converter built with Node.js, featuring a web interface and REST API. It is designed for easy containerization with Docker and orchestration with Kubernetes.

## Features

- Convert between Celsius and Fahrenheit via web interface and REST API.
- Automated tests for conversion functions.
- Ready for Docker containerization.
- Kubernetes manifests for backend and PostgreSQL database deployment.

## Project Structure

- `src/` — Application source code:
  - `server.js`: Main Express server, handles web routes and API endpoints.
  - `convert.js`: Contains temperature conversion logic (Celsius ↔ Fahrenheit).
  - `views/index.ejs`: Web interface for user input and displaying results.
  - `config/system-life.js`: Health and readiness endpoints for container orchestration.
  - `test/convert.js`: Automated tests for conversion functions.
- `k8s/` — Kubernetes deployment manifests:
  - `deploy.yaml`: Deploys PostgreSQL and the web application, exposes services.
- `Dockerfile` — Docker image build configuration.
- `README.md` — Project documentation.

---

## 🚀 Docker Installation

### Linux
```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
```
Log out and log in again to activate the docker group.

### Windows (WSL2, without Docker Desktop)
1. Install WSL2 and Ubuntu from Microsoft Store.
2. In Ubuntu/WSL, run the Linux commands above.
3. Start the Docker service in WSL:
	```bash
	sudo service docker start
	```
4. Test with:
	```bash
	docker run hello-world
	```

---

## 🏃‍♂️ Running Locally

1. Install Node.js dependencies:
	```bash
	npm install
	```
2. Start the local server:
	```bash
	node src/server.js
	```
3. Access the web interface at `http://localhost:8080`.

---

## 🐳 Build and Push Docker Image

1. **Build the image:**
	```bash
	docker build -t [dockerhub-user]/temperature-converter:v1.0 .
	```
2. **Login to Docker Hub:**
	```bash
	docker login
	```
3. **Push to Docker Hub:**
	```bash
	docker push [dockerhub-user]/temperature-converter:v1.0
	docker tag [dockerhub-user]/temperature-converter:v1.0 [dockerhub-user]/temperature-converter:latest
	docker push [dockerhub-user]/temperature-converter:latest
	```
4. **Run the image:**
	```bash
	docker run -p 8080:8080 [dockerhub-user]/temperature-converter:latest
	```

---

## 💸 Donations

If you find this project helpful and would like to support its development, consider making a donation. Your contribution helps keep this toolkit updated and motivates further improvements!

| ☕ Support this project | ☕ Apoie este projeto |
|------------------------|----------------------|
| If this project helps you or you think it's cool, consider supporting:<br>💳 [PayPal](https://www.paypal.com/donate/?business=7CC3CMJVYYHAC&no_recurring=0&currency_code=BRL)<br>![PayPal QR code](https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=https://www.paypal.com/donate/?business=7CC3CMJVYYHAC&no_recurring=0&currency_code=BRL) | Se este projeto te ajudar ou você achar legal, considere apoiar:<br>🇧🇷 Pix: `df92ab3c-11e2-4437-a66b-39308f794173`<br>![Pix QR code](https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=df92ab3c-11e2-4437-a66b-39308f794173) |

---

## Author

Nilson Sangy