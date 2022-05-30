terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "4.16.0"
        }
    }
    required_version = ">= 0.13"
    backend "s3" {
        bucket = "practica-final-cicd"
        region = "eu-west-1"
        encrypt = true
    }
    
}
#AWS Provider
provider "aws" {
    region = "eu-west-1"

}
#Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "practica-final-cicd-${var.environment}"
#   acl    = "private"

#   tags {
#     Name        = "practica-final-cicd"
#     Environment = "Dev"
#   }
}