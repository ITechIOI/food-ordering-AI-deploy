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

# Cài PyTorch + CUDA từ repo chính thức
RUN pip install --no-cache-dir \
    torch==2.0.1+cu118 torchvision==0.15.2+cu118 torchaudio==2.0.2 \
    --index-url https://download.pytorch.org/whl/cu118

# Cài các gói khác (trừ torch*)
COPY requirements.txt .

# REMOVE TORCH from requirements.txt (nếu còn dòng torch)
RUN sed -i '/torch/d' requirements.txt && \
    pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ mã nguồn (nếu cần để build thêm lib nội bộ)
COPY . .

# ===================================
# 🚀 Runtime Stage
# ===================================
FROM python:3.11-slim

WORKDIR /app

# Copy tất cả package từ stage trước
COPY --from=builder /usr/local /usr/local

# Copy project source
COPY . .

# Mở cổng FastAPI
EXPOSE 8000

# Chạy FastAPI app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
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

# Cài PyTorch + CUDA từ repo chính thức
RUN pip install --no-cache-dir \
    torch==2.0.1+cu118 torchvision==0.15.2+cu118 torchaudio==2.0.2 \
    --index-url https://download.pytorch.org/whl/cu118

# Cài các gói khác (trừ torch*)
COPY requirements.txt .

# REMOVE TORCH from requirements.txt (nếu còn dòng torch)
RUN sed -i '/torch/d' requirements.txt && \
    pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ mã nguồn (nếu cần để build thêm lib nội bộ)
COPY . .

# ===================================
# 🚀 Runtime Stage
# ===================================
FROM python:3.11-slim

WORKDIR /app

# Copy tất cả package từ stage trước
COPY --from=builder /usr/local /usr/local

# Copy project source
COPY . .

# Mở cổng FastAPI
EXPOSE 8000

# Chạy FastAPI app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
