# Initialise terraform
# Providers - AWS

# This code will eventually launch an EC2 instance for us

# provider is a keyword in Terraform to define the name of cloud provider

# syntax:

provider "aws"{
    region = "eu-west-1"
}

# launching an EC2 instance from our webapp AMI
# resource is the keyword


resource "aws_instance" "app_instance" {
    # add AMI id
    ami = "ami-09f4421394f9096d9"

    # add the type of instance
    instance_type = "t2.micro"

    # do we enable public IP for app?
    associate_public_ip_address = true

    # tags to give name to our instance
    tags = {
        Name = "eng84_isobel_terraform_node_app"
    }

    # set key to use
    key_name = "eng84devops"

    # set subnet
    # subnet_id = aws_subnet.eng84_isobel_terraform_subnet_public.id
}


resource "aws_vpc" "Terraform_vpc_code_test" {
    cidr_block = "10.0.0.0/16"

    instance_tenancy = "default"

    tags = {
        Name = "eng84_isobel_vpc_terraform_app"
    }
}


resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.Terraform_vpc_code_test.id
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "eng84_isobel_terraform_subnet_public"
    }
}
