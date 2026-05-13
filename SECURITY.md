# 🔐 SECURITY POLICY — STATUSPULSE

---

# 📌 1. SECURITY OVERVIEW

StatusPulse follows DevSecOps practices to ensure the application, infrastructure, and CI/CD pipeline are secure from vulnerabilities, unauthorized access, and data leaks.

---

# 🔑 2. SECRET MANAGEMENT

All sensitive credentials are securely stored in:

👉 GitHub Secrets  
Location: GitHub Repository → Settings → Secrets and Variables → Actions

## Secrets used:

- DB_NAME → Database name
- DB_USER → Database username
- DB_PASSWORD → Database password
- SERVER_IP → EC2 public IP
- SERVER_USER → EC2 SSH user
- SSH_PRIVATE_KEY → EC2 login key

## Usage:

Secrets are injected into GitHub Actions as environment variables at runtime:

```bash
DB_PASSWORD=${{ secrets.DB_PASSWORD }}
