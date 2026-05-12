# =========================
# Builder Stage
# =========================
FROM python:3.12-slim AS builder

# Prevent Python buffering
ENV PYTHONUNBUFFERED=1

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy requirements first (layer caching optimization)
COPY app/requirements.txt .

# Install dependencies into custom directory
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# =========================
# Runtime Stage
# =========================
FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    curl \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r appgroup && \
    useradd -r -g appgroup appuser

# Create application directory
WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /install /usr/local

# Copy application code
COPY app/ ./app/

# Set ownership
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 8000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
CMD curl -f http://localhost:8000/health || exit 1

# Start application
CMD ["gunicorn", "-w", "2", "-k", "uvicorn.workers.UvicornWorker", \
     "-b", "0.0.0.0:8000", "app.main:app"]
