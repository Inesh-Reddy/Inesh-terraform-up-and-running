/* The first step to using Terraform is typically to configure 
the provider(s) you want to use.  */

provider "aws"{
    region = "us-east-2"
}

resource "aws_instance" "example"{
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"

    tags = {
        name = "Terraform-example"
    }
}


