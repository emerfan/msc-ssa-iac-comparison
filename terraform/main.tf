terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_id" "rand" {
  // Atlantis branch one
  byte_length = 5
}

resource "aws_s3_bucket" "demo" {
  bucket        = "demo-bucket-${random_id.rand.hex}"
  force_destroy = true

  tags = {
    Environment = "Dev"
    Owner       = "Emer"
    Purpose      = "Msc"
    Modu      = "Infra"
  }
}

resource "aws_s3_bucket_versioning" "demo_versioning" {
  bucket = aws_s3_bucket.demo.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_user" "demo_user" {
  name = "demo-user_change_2"
}

resource "aws_iam_user" "demo_user_atl" {
  name = "demo-user_change"
}

resource "aws_iam_user_policy" "demo_policy" {
  name   = "demo-policy"
  user   = aws_iam_user.demo_user.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:*"]
      Resource = [
        aws_s3_bucket.demo.arn,
        "${aws_s3_bucket.demo.arn}/*"
      ]
    }]
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "demo_encryption" {
  bucket = aws_s3_bucket.demo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}




