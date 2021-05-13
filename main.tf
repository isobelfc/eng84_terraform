# Initialise terraform

# This code will eventually launch an EC2 instance for us
# var.name_of_resource loads a variable from variable.tf

# provider is a keyword in Terraform to define the name of cloud provider

provider "aws"{
    region = var.region
}

# launching an EC2 instance from our webapp AMI
# resource is the keyword


resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"

    instance_tenancy = "default"

    tags = {
        Name = "eng84_isobel_vpc_terraform_app"
    }
}


resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "eng84_isobel_terraform_app_ig"
    }
}


resource "aws_subnet" "subnet_1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-1a"

    tags = {
        Name = "eng84_isobel_terraform_subnet_1"
    }
}


resource "aws_subnet" "subnet_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-1b"

    tags = {
        Name = "eng84_isobel_terraform_subnet_2"
    }
}


resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
        Name = var.name
    }
}


resource "aws_route_table_association" "rt_association" {
  subnet_id = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table.id
}


resource "aws_security_group" "app_sg" {
    name = "eng84_isobel_terraform_test"
    description = "app group"
    vpc_id = aws_vpc.vpc.id

    # inbound rules
    ingress {
        from_port = "80"  # to launch in the browser
        to_port = "80"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # allow all
    }

    ingress {
        from_port = "22"  # to ssh into
        to_port = "22"
        protocol = "tcp"
        cidr_blocks = ["${var.my_ip}"]  # from my ip only
    }

    # outbound rules
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"  # allow all
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = var.name
    }
}


resource "aws_instance" "app_instance" {
    # add AMI id
    ami = var.webapp_ami_id

    # add the type of instance
    instance_type = "t2.micro"

    # do we enable public IP for app?
    associate_public_ip_address = true

    # tags to give name to our instance
    tags = {
        Name = "${var.name}"
    }

    # set key to use
    key_name = "${var.aws_key_name}"

    # add security groups
    vpc_security_group_ids = ["${aws_security_group.app_sg.id}"]

    # set subnet - add this line after creation of subnet
    subnet_id = aws_subnet.subnet_1.id

    # provisioner "file" {
    #   source      = "./scripts/app/init.sh.tpl"
    #   destination = "/etc"
    # }

}


resource "aws_lb" "lb" {
    name = "eng84-isobel-terraform-lb-1"
    load_balancer_type = "application"
    security_groups = [aws_security_group.app_sg.id]
    subnets = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
}


resource "aws_lb_target_group" "lb_tg" {
    name = "eng84-isobel-tf-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
}


resource "aws_autoscaling_group" "asg" {
    name = var.name
    availability_zones = ["eu-west-1a"]
    desired_capacity = 1
    max_size = 1
    min_size = 1
    # target_group_arns = [aws_lb_target_group.lb_tg.id]  # attach load balancer

    launch_template {
        id = var.launch_template_id
        version = "$Latest"
    }
}
