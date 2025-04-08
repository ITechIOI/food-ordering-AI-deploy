# ===================================
# 🏗️ Build Stage
# ===================================
FROM python:3.11-slim as builder

WORKDIR /app

# Cài gói cần thiết để build + dọn sạch cache ngay sau đó
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc curl && \
    rm -rf /var/lib/apt/lists/*

# Cập nhật pip
RUN pip install --upgrade pip

# Sao chép requirements.txt và cài các gói (không cần lọc torch nữa nếu đã bỏ khỏi file)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ mã nguồn
COPY . .

# ===================================
# 🚀 Runtime Stage
# ===================================
FROM python:3.11-slim

WORKDIR /app

# Copy toàn bộ dependencies từ stage builder
COPY --from=builder /usr/local /usr/local

# Copy project source
COPY . .

# Mở cổng FastAPI
EXPOSE 8000

# Chạy FastAPI app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
