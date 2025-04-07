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

# ⚙️ Cài PyTorch CPU-only (bản chính thức không có CUDA)
RUN pip install --no-cache-dir \
    torch==2.5.1 torchvision==0.20.1 

# Copy và xử lý requirements.txt (loại bỏ torch*)
COPY requirements.txt .
RUN sed -i '/torch/d' requirements.txt && \
    pip install --no-cache-dir -r requirements.txt

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
