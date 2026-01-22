# Stage 1: Build
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --prefix=/install --no-cache-dir -r requirements.txt

# Stage 2: Production
FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .
RUN addgroup --system app && adduser --system --group app \
    && chown -R app:app /app
USER app
EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "run:app"]
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/ || exit 1


