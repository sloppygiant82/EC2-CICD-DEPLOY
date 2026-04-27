terraform {
  backend "s3" {
    bucket       = "aws-two-tier-248965576334-us-east-1-an"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}