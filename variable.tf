# variable.tf

variable "vpc_id" {
    default = ""
}

variable "name" {
    default = "eng84_isobel_terraform"
}

variable "webapp_ami_id" {
    default = "ami-09f4421394f9096d9"
}

variable "db_ami_id" {
    default = "ami-098bc304c16c31c4b"
}

variable "aws_subnet" {
    default = "vpc-07e47e9d90d2076da"
}

variable "aws_key_name" {
    default = "eng84devops"
}

variable "aws_key_path" {
    default = "~/.ssh/eng84devops.pem"
}
