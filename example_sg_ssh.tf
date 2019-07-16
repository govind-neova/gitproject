resource "aws_security_group" "first-security-group"{
  name        = "ssh-allow-SG"
  description = "ssh-allow-SG"
  
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


provider "aws" {
  profile = "default"
  region  = "us-east-1"   
}

resource "aws_instance" "example"{
  ami                                   = "ami-2757f631"
  instance_type                         = "t2.micro"
  availability_zone                     = "us-east-1a"
  instance_initiated_shutdown_behavior  = "stop"
  disable_api_termination               = "false"  
  key_name = "Verginia"
  security_groups = ["${aws_security_group.first-security-group.name}"]  

  tags = {
    Name = "First-aws-inst"
 }
}
