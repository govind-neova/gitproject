resource "aws_subnet" "PUB-SUB-1" {
  vpc_id                   = "${aws_vpc.main.id}"
  cidr_block               = "10.0.1.0/24"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = true

  tags = {
    Name = "10.0.1.0/24-us-east-1a-PUB"
  }
}

resource "aws_subnet" "PRIV-SUB-2" {
  vpc_id                          = "${aws_vpc.main.id}"
  cidr_block                      = "10.0.3.0/24"
  availability_zone               = "us-east-1a"

  tags = {
    Name = "10.0.1.0/24-us-east-1a-PRIV"
  }
}

resource "aws_subnet" "subnet-programmed" {
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 5, 1)}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "10.0.1.0/24-us-east-1a-PROGRAMATIC"
  }
}


resource "aws_subnet" "subnet-programmed-2" {
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 2, 1)}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "10.0.1.0/24-us-east-1a-PRIV-3"
  }
}
