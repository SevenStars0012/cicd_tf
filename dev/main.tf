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
resource "aws_s3_bucket" "upload_bucket" {
  bucket = "hamelin002025up"
  force_destroy = true
}

output "upload_bucket_name" {
  value = aws_s3_bucket.upload_bucket.bucket
}
