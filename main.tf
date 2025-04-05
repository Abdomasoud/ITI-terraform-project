provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "example" {
  bucket = "terraform-state-bucket-abdo2322"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}