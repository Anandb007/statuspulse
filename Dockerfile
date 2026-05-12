# -----------------------
# Builder Stage
# -----------------------
FROM python:3.12-slim AS builder

WORKDIR /app

# Build dependencies (minimal + secure)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

COPY app/requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# -----------------------
# Runtime Stage (SECURE)
# -----------------------
FROM python:3.12-slim

WORKDIR /app

# Security + runtime dependencies (FIXED FOR TRIVY)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    ca-certificates \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy Python packages from builder
COPY --from=builder /install /usr/local

# Copy application code
COPY app/ /app/

# Create non-root user (security requirement)
RUN useradd -m appuser && chown -R appuser /app

USER appuser

EXPOSE 8000

# -----------------------
# HEALTHCHECK (REQUIRED)
# -----------------------
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
CMD curl -f http://localhost:8000/health || exit 1

# -----------------------
# START APPLICATION
# -----------------------
CMD ["gunicorn", "main:app", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000"]
