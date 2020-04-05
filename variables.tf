variable "name" {
  type    = string
  default = "bastion"
}

variable "tags" {
  type = map
  default = {
    Name      = "bastion"
    Terraform = "true"
  }
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "volume_type" {
  type    = string
  default = "gp"
}

variable "volume_size" {
  type    = number
  default = 8
}
