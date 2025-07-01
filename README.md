# AWS Lambda với LocalStack

AWS Lambda là một dịch vụ điện toán của Amazon cho phép bạn chạy hàm (function) dựa trên sự kiện, mà không cần triển khai hoặc quản lý máy chủ (serverless).
Các sự mà s3 hỗ trợ trigger
s3:ObjectCreated:*	Bất kỳ khi nào một object mới được tạo	Phổ biến nhất
s3:ObjectCreated:Put	Khi upload file bằng lệnh PUT	
s3:ObjectCreated:Post	Upload qua form HTML	
s3:ObjectCreated:Copy	Khi một object được sao chép	
s3:ObjectCreated:CompleteMultipartUpload	Khi upload nhiều phần hoàn tất	
s3:ObjectRemoved:*	Khi object bị xoá	
s3:ObjectRemoved:Delete	Xoá bằng lệnh DELETE	
s3:ObjectRemoved:DeleteMarkerCreated	Khi tạo delete marker (phiên bản hoá)
---

## Hướng dẫn tạo Lambda đơn giản với LocalStack

### 1. Cấu hình AWS CLI (dùng fake credentials)
```bash
aws configure
# AWS Access Key ID: test
# AWS Secret Access Key: test
# Default region name: us-east-1
```

### 2. Tạo S3 bucket
```bash
aws --endpoint-url=http://localhost:4566 s3api create-bucket --bucket demo-bucket
```

### 3. Đóng gói Lambda thành file zip
```bash
zip function.zip lambda_function.py
```

### 4. Tạo Lambda function
```bash
aws --endpoint-url=http://localhost:4566 lambda create-function \
  --function-name my-s3-lambda \
  --runtime python3.9 \
  --handler lambda_function.lambda_handler \
  --role arn:aws:iam::000000000000:role/fake-role \
  --zip-file fileb://function.zip \
  --region us-east-1
```

### 5. Gắn trigger từ S3 → Lambda
```bash
aws --endpoint-url=http://localhost:4566 s3api put-bucket-notification-configuration \
  --bucket demo-bucket \
  --notification-configuration '{
    "LambdaFunctionConfigurations": [
      {
        "LambdaFunctionArn": "arn:aws:lambda:us-east-1:000000000000:function:my-s3-lambda",
        "Events": ["s3:ObjectCreated:*"]
      }
    ]
  }'
```

### 6. Kiểm tra trigger đã được gắn thành công chưa
```bash
aws --endpoint-url=http://localhost:4566 s3api get-bucket-notification-configuration \
  --bucket demo-bucket
```

### 7. Tạo file test và upload lên S3 bucket
```bash
echo "Hello LocalStack" > test.txt
aws --endpoint-url=http://localhost:4566 s3 cp test.txt s3://demo-bucket/test.txt
```

> **Lưu ý:**
> LocalStack log sẽ in trong terminal nội dung `print` trong `lambda_function.py` khi Lambda được kích hoạt.
