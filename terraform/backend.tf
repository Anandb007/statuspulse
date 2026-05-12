terraform {
  backend "s3" {
    bucket         = "statuspulse-terraform-state-12345"
    key            = "statuspulse/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
