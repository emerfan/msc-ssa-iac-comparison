terraform {
  backend "s3" {
    bucket         = "msc-terraform-state-bucket"
    key            = "msc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
