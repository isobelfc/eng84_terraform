# variable.tf

variable "my_ip" {
    default = "195.213.42.218/32"  # replace with own ip
}

variable "name" {
    default = "eng84_isobel_terraform"
}

variable "region" {
    default = "eu-west-1"
}

variable "vpc_id" {
    default = "vpc-07e47e9d90d2076da"
}

variable "webapp_ami_id" {
    default = "ami-028079c0f4d1eafd0"
}

variable "db_ami_id" {
    default = "ami-0eafa5cb3aad861de"
}

variable "aws_subnet" {
    default = "subnet-013b0b0deea20b0e5"
}

variable "aws_key_name" {
    default = "eng84devops"
}

variable "aws_key_path" {
    default = "~/.ssh/eng84devops.pem"
}
