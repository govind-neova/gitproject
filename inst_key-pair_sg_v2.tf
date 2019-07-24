
provider "aws" {
  region = "us-east-1"
}

//========================================== VARIABLES =====================================================//

variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default = "10.1.0.0/24"
}
variable "availability_zone" {
  description = "availability zone to create subnet"
  default = "us-east-2a"
}
variable "public_key_path" {
  description = "Public key path"
  default = "~/.ssh/id_rsa.pub"
}
variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-0b898040803850657"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}
variable "environment_tag" {
  description = "Environment tag"
  default = "Production"
}

variable "http_ports" {
  default = ["22","80", "443", "8080", "8443"]
}

//============================================ SECURITY GROUPS  ==============================================================//

resource "aws_security_group" "sg_23" {
  name = "sg_23"


//  ingress {
//      from_port   = 22
//      to_port     = 22
//      protocol    = "tcp"
//      cidr_blocks = ["0.0.0.0/0"]
//  }

//  egress {
//    from_port   = 0
//    to_port     = 0
//    protocol    = "-1"
//    cidr_blocks = ["0.0.0.0/0"]
//  }
 
  tags = {
      Name = "CUSTOM-SG1"  
  }

}

resource "aws_security_group_rule" "ingress_http" {
  count = "${length(var.http_ports)}"

  type        = "ingress"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = "${element(var.http_ports, count.index)}"
  to_port     = "${element(var.http_ports, count.index)}"

  security_group_id = "${aws_security_group.sg_23.id}"
}

//resource "aws_security_group_rule" "ingress_http" {
//  type        = "ingress"
//  from_port   = 80
//  to_port     = 80
//  protocol    = "-1"
//  cidr_blocks = ["0.0.0.0/0"]
//  security_group_id = "${aws_security_group.sg_23.id}"
//}

//========================================== KEY PAIR =====================================================================//

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2key" {
  key_name   = "publicKey"
  public_key = "${tls_private_key.example.public_key_openssh}"
}

//=============================================== CREATING INSTANCES =======================================================================//

resource "aws_instance" "testInstance" {
  ami              = "${var.instance_ami}"
  instance_type    = "${var.instance_type}"
//  subnet_id      = "${aws_subnet.subnet_public.id}"
  security_groups  = ["${aws_security_group.sg_23.name}"]
  key_name         = "${aws_key_pair.ec2key.key_name}"
  tags             = {
                       Environment = "${var.environment_tag}"
         }
}
