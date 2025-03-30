provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "web_bucket" {
  bucket = "hamelin002025"
  force_destroy = true
}

output "bucket_name" {
  value = aws_s3_bucket.web_bucket.bucket
}