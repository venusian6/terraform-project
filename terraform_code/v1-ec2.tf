provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "demo" {
ami = "ami-0d682f26195e9ec0f"
instance_type = "t2.micro"

}