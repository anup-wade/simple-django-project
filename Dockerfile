# ------------------------------
# 1. Base image
# ------------------------------
FROM python:3.10-slim

# Prevent Python from buffering stdout/stderr
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# ------------------------------
# 2. Install system dependencies
# ------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        && rm -rf /var/lib/apt/lists/*

# ------------------------------
# 3. Copy project files
# ------------------------------
COPY requirements.txt /app/

# ------------------------------
# 4. Install Python dependencies
# ------------------------------
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project
COPY . /app/

# ------------------------------
# 5. Expose port (Cloud Run uses $PORT)
# ------------------------------
EXPOSE 8080

# ------------------------------
# 6. Set environment variable for Cloud Run
# ------------------------------
ENV PORT=8080

# ------------------------------
# 7. Run Django using gunicorn (production)
# ------------------------------
CMD ["gunicorn", "simple_django_project.wsgi:application", "--bind", "0.0.0.0:8080"]
