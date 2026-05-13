terraform {
  backend "s3" {
    bucket       = "daviddigheji-fuelops-tfstate-euw2"
    key          = "ecs-platform/prod/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}