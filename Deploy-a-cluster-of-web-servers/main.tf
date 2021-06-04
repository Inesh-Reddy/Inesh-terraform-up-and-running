# creating an auto scalling group to setup server cluster
provider "aws"{
    region = "us-east-2"
}
resource "aws_security_group" "example"{
    name = "security group for asg"

    ingress{
        from_port = "8080"
        to_port = "8080"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_launch_configuration" "example" {
    name = "asg-servers"
    image_id = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.example.id]

    user_data = <<-EOF
                    echo "hello world" > index.html
                    uohup busybox httpd -f -p 8080 &
                    EOF

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "example"{
    launch_configuration = aws_launch_configuration.example.name
    vpc_zone_identifier = data.aws_subnet_ids.default.ids

    min_size = 2
    max_size = 10

    tag {
        key = "name"
        value = "terraform-asg-example"
        propagate_at_launch = true
    }
} 

data "aws_vpc" "default" {
    default = true
}

data "aws_subnet_ids" "default"{
    vpc_id = data.aws_vpc.default.id
}