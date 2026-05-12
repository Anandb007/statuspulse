# -----------------------
# Builder Stage
# -----------------------
FROM python:3.12-slim AS builder

WORKDIR /app

# Install build dependencies (clean + recommended format)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

COPY app/requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# -----------------------
# Runtime Stage
# -----------------------
FROM python:3.12-slim

WORKDIR /app

# Install only runtime dependencies (no extra packages)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Copy installed python packages
COPY --from=builder /install /usr/local

# Copy application
COPY app/ /app/

# Create non-root user (security requirement)
RUN useradd -m appuser && chown -R appuser /app

USER appuser

EXPOSE 8000

# Healthcheck (required by client)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
CMD curl -f http://localhost:8000/health || exit 1

# Run application
CMD ["gunicorn", "main:app", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000"]
