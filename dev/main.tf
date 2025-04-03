provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "upload_bucket" {
  bucket        = var.upload_bucket
  force_destroy = true
}
