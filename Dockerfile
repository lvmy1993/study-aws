FROM localstack/localstack:latest

# Ví dụ: thêm script hoặc lib
COPY my-custom-init.sh /etc/localstack/init/ready.d/

# Cho phép thực thi
RUN chmod +x /etc/localstack/init/ready.d/my-custom-init.sh
