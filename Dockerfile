# Dockerfile for Clara
FROM python:3.11-slim

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install UV package manager
RUN pip install --no-cache-dir uv

# Set working directory
WORKDIR /app

# Copy all application files
COPY . .

# Install dependencies using uv (creates .venv automatically)
RUN uv sync --no-dev

# Create non-root user and change ownership
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Set PATH to use the venv
ENV PATH="/app/.venv/bin:$PATH"

# Expose port (ADK web interface runs on 6060 to avoid conflict with ArgoCD on 8080)
EXPOSE 6060

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:6060/health || exit 1

# Run the ADK web interface using uv
CMD ["uv", "run", "adk", "web", ".", "--host", "0.0.0.0", "--port", "6060"]

