# Bắt đầu từ image python slim
FROM python:3.11-slim

# Đặt thư mục làm việc
WORKDIR /app

# Cài các thư viện hệ thống cần thiết cho việc build
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc libffi-dev libssl-dev curl && \
    rm -rf /var/lib/apt/lists/*

# Cập nhật pip
RUN pip install --upgrade pip

# Cài đặt PyTorch và các gói liên quan với CUDA 11.3 từ PyTorch index
RUN pip install --no-cache-dir \
    torch==2.0.1+cu118 torchvision==0.15.2+cu118 torchaudio==2.0.2 \
    --index-url https://download.pytorch.org/whl/cu118

# Copy file requirements.txt trước khi cài đặt dependencies
COPY requirements.txt .

# Cài đặt các dependencies từ requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ source code vào image
COPY . .

# Mở port 8000 cho ứng dụng
EXPOSE 8000

# Chạy ứng dụng với uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
