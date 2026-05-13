# 🚀 StatusPulse – CI/CD + Monitoring System

StatusPulse is a production-ready DevOps project demonstrating a complete CI/CD pipeline, containerized microservices, AWS deployment, monitoring, and alerting using modern DevOps tools.

---

## 📌 System Architecture

Developer  
   ↓  
GitHub Repository  
   ↓  
GitHub Actions (CI Pipeline)  
   ├── Ruff Linting  
   ├── Hadolint (Dockerfile Scan)  
   ├── Integration Tests  
   ├── Trivy Security Scan  
   ↓  
Docker Image Build  
   ↓  
GitHub Container Registry (GHCR)  
   ↓  
GitHub Actions (CD Pipeline)  
   ↓  
AWS EC2 (Ubuntu 24.04)  
   ↓  
Docker Compose  
   ├── FastAPI Application (StatusPulse)  
   ├── PostgreSQL Database  
   ├── Redis Cache  
   ↓  
Uptime Kuma (Monitoring) + ntfy (Alerts)  
   ↓  
Public Access: https://52.6.40.101.nip.io/health
GitHub URL: https://github.com/Anandb007/statuspulse

---

## 🧰 Tech Stack

- FastAPI (Backend API)
- PostgreSQL (Database)
- Redis (Caching)
- Docker & Docker Compose
- GitHub Actions (CI/CD)
- GitHub Container Registry (GHCR)
- AWS EC2 (Ubuntu 24.04)
- Uptime Kuma (Monitoring)
- ntfy (Notifications)
- Ruff, Hadolint, Trivy (Quality & Security)

---

## 📋 Prerequisites

- Ubuntu 22.04 / 24.04
- Docker
- Docker Compose
- Git
- AWS EC2 instance (t3.micro)
- GitHub account
- SSH key configured

---

## ⚙️ Run Locally

### 1. Clone Repository
git clone https://github.com/<your-username>/statuspulse.git  
cd statuspulse  

### 2. Environment Variables
DB_NAME=statuspulse  
DB_USER=statuspulse  
DB_PASSWORD=yourpassword  
DB_HOST=postgres  
DB_PORT=5432  

REDIS_HOST=redis  
REDIS_PORT=6379  

### 3. Start Application
docker compose up -d --build  

### 4. Access Services
API: http://localhost:8000  
Docs: http://localhost:8000/docs  
Health: http://localhost:8000/health  

---

## 🚀 Production Deployment (AWS EC2)

- AWS EC2 (Ubuntu 24.04)
- Instance Type: t3.micro
- Public IP: http://52.6.40.101  

Flow:  
GitHub Push → CI Pipeline → Docker Build → GHCR → CD Pipeline → EC2 Deploy → Docker Compose → Health Check  

---

## 🔄 CI/CD Pipeline

### CI
- Code checkout
- Ruff linting
- Hadolint Dockerfile scan
- Trivy security scan
- Integration tests
- Docker build

### CD
- Push image to GHCR
- SSH into EC2
- Pull latest image
- Deploy using Docker Compose
- Health check
- Rollback (if configured)

---

## 📊 Monitoring & Alerts

Uptime Kuma  
http://52.6.40.101:3001  

ntfy Alerts:
curl -d "Service Alert" https://ntfy.sh/statuspulse-alerts  

---

## 💾 Backup & Restore

Backup:
pg_dump -U statuspulse statuspulse > backup.sql  

Restore:
psql -U statuspulse statuspulse < backup.sql  

---

## 🔐 GitHub Secrets

Stored in GitHub → Settings → Secrets and Variables → Actions  

DB_NAME  
DB_USER  
DB_PASSWORD  
SERVER_IP  
SERVER_USER  
SSH_PRIVATE_KEY  

Example:
env:
  DB_PASSWORD: ${{ secrets.DB_PASSWORD }}

---

## 🔧 Troubleshooting

docker ps  
docker logs statuspulse-app  
docker restart statuspulse-app  

---

## 📡 API Endpoints

GET /health  
GET /services  
POST /services  
GET /incidents  

---

## 🧪 Testing

./tests/test_integration.sh  

---

## 🌐 Live URLs

API: http://52.6.40.101:8000  
Docs: http://52.6.40.101:8000/docs  
Monitoring: http://52.6.40.101:3001  

---

## ✅ Features

- Full CI/CD pipeline
- Dockerized microservices
- AWS EC2 deployment
- Monitoring (Uptime Kuma)
- Alerts (ntfy)
- Security scanning (Trivy + Hadolint)
- Automated testing
- Production-ready DevOps workflow

---

## 👨‍💻 Author

StatusPulse DevOps Project  
Production-grade CI/CD + Cloud Deployment system
