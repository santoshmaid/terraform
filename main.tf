provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "sample" {
ami = "ami-0bb5806b2e825a199"
instance_type = "t2.micro"
  tags {
    Name = "terraform-example"
  }
}
