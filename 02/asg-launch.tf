provider "aws" {
  region = "us-west-2"
}

resource "aws_launch_configuration" "example" {
image_id = "ami-0bbe6b35405ecebdb"
instance_type = "t2.micro"
security_groups = ["${aws_security_group.instance.id}"]


  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, Terraform" > index.html
    nohup busybox httpd -f -p "${var.server_port}" &
    EOF

  lifecycle {
    create_before_destroy = true
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

    lifecycle {
        create_before_destroy = true
      }

    }

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  min_size = 0
  max_size = 2

  tag {
  key     = "Name"
  value   = "terraform-asg-example"
  propagate_at_launch = true
  }

}

data "aws_availability_zones" "all" {}



#output "public_ip" {
#  value = "${aws_instance.example.public_ip}"
#}
