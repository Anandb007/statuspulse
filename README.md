#                     🚀 StatusPulse – CI/CD + Monitoring System

<div align="center">

![FastAPI](https://img.shields.io/badge/FastAPI-Backend-009688?style=for-the-badge&logo=fastapi)
![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?style=for-the-badge&logo=docker)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI/CD-2088FF?style=for-the-badge&logo=github-actions)
![AWS](https://img.shields.io/badge/AWS-EC2-FF9900?style=for-the-badge&logo=amazonaws)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-336791?style=for-the-badge&logo=postgresql)
![Redis](https://img.shields.io/badge/Redis-Cache-DC382D?style=for-the-badge&logo=redis)

DevOps project demonstrating a complete CI/CD pipeline, containerized microservices, cloud deployment, monitoring, alerting, and automated testing using modern DevOps tools.

</div>

---

# 📌 Overview

**StatusPulse** is a DevOps-focused monitoring platform designed to showcase real-world production deployment practices.

The project includes:

- ✅ CI/CD automation with GitHub Actions
- ✅ Dockerized microservices architecture
- ✅ AWS EC2 deployment
- ✅ Monitoring & uptime tracking
- ✅ Security scanning
- ✅ Health checks & automated deployment
- ✅ PostgreSQL + Redis integration
- ✅ Production-ready infrastructure

---

# 🏗️ System Architecture

```text
Developer
   ↓
GitHub Repository
   ↓
GitHub Actions (CI Pipeline)
   ├── Ruff Linting
   ├── Hadolint Docker Scan
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
   ├── FastAPI Application
   ├── PostgreSQL Database
   ├── Redis Cache
   ↓
Uptime Kuma Monitoring
   ↓
ntfy Alert Notifications
   ↓
Public Health Endpoint
```

---

# 🧰 Tech Stack

| Category | Technology |
|---|---|
| Backend API | FastAPI |
| Database | PostgreSQL |
| Cache | Redis |
| Containerization | Docker & Docker Compose |
| CI/CD | GitHub Actions |
| Registry | GitHub Container Registry (GHCR) |
| Cloud Provider | AWS EC2 |
| Monitoring | Uptime Kuma |
| Notifications | ntfy |
| Security | Trivy |
| Linting | Ruff |
| Docker Scanning | Hadolint |

---

# 🌐 Live Deployment

| Service | URL |
|---|---|
| API | http://52.6.40.101:8000 |
| Swagger Docs | http://52.6.40.101:8000/docs |
| Health Check | https://52.6.40.101.nip.io/health |
| Monitoring Dashboard | http://52.6.40.101:3001 |
| GitHub Repository | https://github.com/Anandb007/statuspulse |

---

# ⚙️ Local Development Setup

## 1️⃣ Clone Repository

```bash
git clone https://github.com/Anandb007/statuspulse.git

cd statuspulse
```

---

## 2️⃣ Configure Environment Variables

Create a `.env` file:

```env
DB_NAME=statuspulse
DB_USER=statuspulse
DB_PASSWORD=yourpassword
DB_HOST=postgres
DB_PORT=5432

REDIS_HOST=redis
REDIS_PORT=6379
```

---

## 3️⃣ Start Services

```bash
docker compose up -d --build
```

---

## 4️⃣ Access Application

| Service | URL |
|---|---|
| API | http://localhost:8000 |
| Swagger Docs | http://localhost:8000/docs |
| Health Check | http://localhost:8000/health |

---
# 🌐 Caddy Reverse Proxy Configuration

The application uses **Caddy** as a reverse proxy to provide:

- Automatic HTTPS
- Secure headers
- Gzip compression
- Reverse proxy routing to FastAPI
- Production-grade web server configuration

---

## 📄 Caddy Configuration

Location:

```bash
/etc/caddy/Caddyfile
```

Configuration:

```caddy
52.6.40.101.nip.io {

    encode gzip

    reverse_proxy localhost:8000

    header {
        Strict-Transport-Security "max-age=31536000;"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "DENY"
        X-XSS-Protection "1; mode=block"
    }
}
```

---

## 🔐 Security Features Enabled

| Feature | Purpose |
|---|---|
| HTTPS | Automatic TLS certificates |
| Gzip Compression | Faster response delivery |
| HSTS | Enforces secure HTTPS connections |
| X-Content-Type-Options | Prevents MIME sniffing |
| X-Frame-Options | Prevents clickjacking |
| X-XSS-Protection | Basic XSS protection |

---

## 🚀 Public Access

| Service | URL |
|---|---|
| Application Health Check | https://52.6.40.101.nip.io/health |
| Swagger API Docs | https://52.6.40.101.nip.io/docs |


---
# 🚀 Production Deployment

## AWS Infrastructure

| Component | Details |
|---|---|
| Cloud Provider | AWS |
| OS | Ubuntu 24.04 |
| Instance Type | t3.micro |
| Deployment Method | GitHub Actions + SSH |
| Container Runtime | Docker Compose |

---

## Deployment Workflow

```text
GitHub Push
   ↓
CI Pipeline
   ↓
Docker Build
   ↓
Push to GHCR
   ↓
CD Pipeline
   ↓
SSH into EC2
   ↓
Docker Compose Deployment
   ↓
Health Verification
```

---

# 🔄 CI/CD Pipeline

## ✅ Continuous Integration (CI)

The CI pipeline automatically performs:

- Source code checkout
- Ruff linting
- Dockerfile scanning with Hadolint
- Security scanning with Trivy
- Integration testing
- Docker image build validation

---

## 🚀 Continuous Deployment (CD)

The CD pipeline automatically:

- Pushes Docker images to GHCR
- Connects to AWS EC2 via SSH
- Pulls latest container images
- Restarts services with Docker Compose
- Performs health checks
- Supports rollback strategy

---

# 📊 Monitoring & Alerting

## Uptime Kuma Monitoring

Monitor application uptime and health:

```text
http://52.6.40.101:3001
```

---

## ntfy Alert Notifications

Send instant alerts:

```bash
curl -d "Service Alert" https://ntfy.sh/statuspulse-alerts
```

---

# 📡 API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | `/health` | Application health status |
| GET | `/services` | List monitored services |
| POST | `/services` | Create new service |
| GET | `/incidents` | View incidents |

---

# 🧪 API Testing Examples

## Health Check

```bash
curl -i http://52.6.40.101:8000/health
```

### Response

```json
{
  "status": "healthy",
  "checks": {
    "api": "healthy",
    "database": "healthy",
    "redis": "healthy"
  },
  "timestamp": "2026-05-13T05:18:47.016706+00:00"
}
```

---

## Get Services

```bash
curl -i http://52.6.40.101:8000/services
```

### Response

```json
[
  {
    "id": 1,
    "name": "google",
    "url": "https://google.com",
    "status": "unknown",
    "last_checked": "None",
    "response_time_ms": null
  }
]
```

---

## Create Service

```bash
curl -X POST http://52.6.40.101:8000/services \
  -H "Content-Type: application/json" \
  -d '{
    "name": "payment-service",
    "url": "https://payment.example.com",
    "status": "active"
  }'
```

---

## Get Incidents

```bash
curl -i http://52.6.40.101:8000/incidents
```

### Response

```json
[]
```

---

# 💾 Backup & Restore

## PostgreSQL Backup

```bash
pg_dump -U statuspulse statuspulse > backup.sql
```

---

## PostgreSQL Restore

```bash
psql -U statuspulse statuspulse < backup.sql
```

---

# 🔐 GitHub Secrets

Configure the following secrets inside:

```text
GitHub → Settings → Secrets and Variables → Actions
```

| Secret Name |
|---|
| DB_NAME |
| DB_USER |
| DB_PASSWORD |
| SERVER_IP |
| SERVER_USER |
| SSH_PRIVATE_KEY |

---

## Example Usage

```yaml
env:
  DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
```

---

# 🧪 Testing

Run integration tests:

```bash
./tests/test_integration.sh
```

---

# 🔧 Troubleshooting

## View Running Containers

```bash
docker ps
```

---

## View Logs

```bash
docker logs statuspulse-app
```

---

## Restart Application

```bash
docker restart statuspulse-app
```

---

# ✅ Features

- Full CI/CD automation
- Dockerized architecture
- Production deployment on AWS
- Monitoring dashboard
- Real-time alert notifications
- Security scanning
- Integration testing
- Health monitoring
- Infrastructure automation
- Production-ready workflow

---

# 📁 Project Structure

```text
statuspulse/
│
├── app/
├── tests/
├── docker-compose.yml
├── Dockerfile
├── .github/workflows/
├── requirements.txt
├── .env
└── README.md
```

---

# 🔒 Security & Quality Tools

| Tool | Purpose |
|---|---|
| Ruff | Python linting |
| Hadolint | Dockerfile analysis |
| Trivy | Vulnerability scanning |
| GitHub Actions | CI/CD automation |

---

# 👨‍💻 Author

## Anand B

DevOps Engineer | Cloud & Infrastructure Enthusiast

GitHub:  
https://github.com/Anandb007

---

# ⭐ Support

If you found this project useful:

- ⭐ Star the repository
- 🍴 Fork the project
- 🛠️ Contribute improvements

---

# 📜 License

This project is licensed under the MIT License.
