# Multi-stage Dockerfile for Clara
# Stage 1: Build dependencies
FROM python:3.11-slim as builder

# Install UV package manager
RUN pip install --no-cache-dir uv

# Set working directory
WORKDIR /app

# Copy dependency files
COPY pyproject.toml ./

# Create virtual environment and install dependencies
RUN uv venv /opt/venv && \
    . /opt/venv/bin/activate && \
    uv pip install --system -r <(uv pip compile pyproject.toml)

# Stage 2: Runtime
FROM python:3.11-slim

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy virtual environment from builder
ENV PATH="/opt/venv/bin:$PATH"
COPY --from=builder /opt/venv /opt/venv

# Set working directory
WORKDIR /app

# Copy application code
COPY . .

# Create non-root user
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app
USER appuser

# Expose port (ADK web interface runs on 6060 to avoid conflict with ArgoCD on 8080)
EXPOSE 6060

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:6060/health || exit 1

# Run the ADK web interface
CMD ["uv", "run", "adk", "web", ".", "--host", "0.0.0.0", "--port", "6060"]

