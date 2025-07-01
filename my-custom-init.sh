#!/bin/bash
echo "Running custom LocalStack init script..."

# Tạo bucket S3 tự động
awslocal s3 mb s3://my-test-bucket

# Tạo queue
awslocal sqs create-queue --queue-name my-queue
