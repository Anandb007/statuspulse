# -----------------------
# Builder Stage
# -----------------------
FROM python:3.12-slim AS builder

WORKDIR /app

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

# IMPORTANT FIX: add curl for HEALTHCHECK + keep minimal packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 curl \
    && rm -rf /var/lib/apt/lists/*

# Copy python packages
COPY --from=builder /install /usr/local

# Copy app
COPY app/ /app/

# Create non-root user
RUN useradd -m appuser && chown -R appuser /app

USER appuser

EXPOSE 8000

# HEALTHCHECK FIXED (reliable + production-safe)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
CMD curl -f http://localhost:8000/health || exit 1

# Run app
CMD ["gunicorn", "main:app", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000"]
