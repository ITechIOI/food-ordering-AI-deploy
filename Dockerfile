# 🐍 Base Image dùng cho cả build & runtime
FROM python:3.11-slim

# Thiết lập thư mục làm việc
WORKDIR /app

# Cài thư viện hệ thống tối thiểu
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc curl && \
    rm -rf /var/lib/apt/lists/*

# Cập nhật pip
RUN pip install --upgrade pip

# ⚙️ Cài PyTorch CPU-only
RUN pip install --no-cache-dir \
    torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1

# Sao chép requirements.txt & cài thư viện còn lại
COPY requirements.txt .
# Đảm bảo bạn đã xóa/comment các dòng torch* trong requirements.txt
RUN sed -i '/torch/d' requirements.txt && \
    pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ mã nguồn
COPY . .

# Mở cổng FastAPI
EXPOSE 8000

# Chạy app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
