provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami = "ami-0bbe6b35405ecebdb"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, Terraform" > index.html
    nohup busybox httpd -f -p "${var.server_port}" &
    EOF

  tags {
      Name = "terraform-example"
    }
  }

variable "server_port" {
  description = "Web port for http requests"
  default = 8080
  type = "string"
}


resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress {
      from_port = "${var.server_port}"
      to_port   = "${var.server_port}"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      }
    }

output "public_ip" {
  value = "${aws_instance.example.public_ip}"

}
