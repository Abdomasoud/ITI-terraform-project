

terraform {
  backend "s3" {
    bucket  = "terraform-state-bucket-abdo2322"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    # region  = "eu-central-1"
    encrypt = true
    # dynamodb_table = "your-lock-table"
  }
}