resource "aws_vpc" "main"{
  cidr_block       = "10.0.0.0/16" 
//  instance_tenancy = default
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "main"
  }  
}

// SECURITY GROUPS 

resource "aws_security_group" "ingress-all-main" {
  name      = "allow-all-sg"
  vpc_id    = "${aws_vpc.main.id}"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  from_port = 22
    to_port = 22
    protocol = "tcp"
}

// Terraform removes the default rule
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }
  
  tags = {
    Name = "main-vpc-SG"
  }
}

// PUBLIC servers.tf

resource "aws_instance" "main-ec2-instance" {
  ami                     = "ami-0b898040803850657"
  instance_type           = "t2.micro"
  key_name                = "Verginia"
  security_groups         = ["${aws_security_group.ingress-all-main.id}"]
  disable_api_termination = false
  tags = {
    Name = "PUBLIC-INATANCE"
  }
  subnet_id = "${aws_subnet.PUB-SUB-1.id}"
}

// PRIVATE servers.tf

resource "aws_instance" "main-ec2-instance-PRIV" {
  ami                     = "ami-0b898040803850657"
  instance_type           = "t2.micro"
  key_name                = "Verginia"
  security_groups         = ["${aws_security_group.ingress-all-main.id}"]
  disable_api_termination = false
  tags = {
    Name = "PRIVATE-INSTANCE"
  }
  subnet_id = "${aws_subnet.PRIV-SUB-2.id}"
}

//gateways.tf

resource "aws_internet_gateway" "main-gw" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name = "main-GW"
  }
}

// Nat IP

resource "aws_eip" "nat" {
  vpc = true
}

//NAT gateways.tf

resource "aws_nat_gateway" "main-nat-gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.PUB-SUB-1.id}"
  tags = {
    Name = "main-nat-GW"
  }
}

// PUBLIC ROUTE TABLE

resource "aws_route_table" "route-table-main" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-gw.id}"
  }
    tags = {
      Name = "main-vpc-route-table"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.PUB-SUB-1.id}"
  route_table_id = "${aws_route_table.route-table-main.id}"
}

// PRIVATE ROUTE TABLE

resource "aws_route_table" "route-table-main-PRIVATE" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.main-nat-gw.id}"
  }
    tags = {
      Name = "main-PRIV-vpc-route-table"
  }
}
resource "aws_route_table_association" "subnet-association-PRIV" {
  subnet_id      = "${aws_subnet.PRIV-SUB-2.id}"
  route_table_id = "${aws_route_table.route-table-main-PRIVATE.id}"
}
