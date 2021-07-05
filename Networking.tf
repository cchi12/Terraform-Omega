### root/networking.tf

resource "aws_vpc" "Omega_vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "Omega_vpc"
  }
}

resource "aws_internet_gateway" "Omega-igw" {
  vpc_id = aws_vpc.Omega_vpc.id

  tags = {
    Name = "Omega-igw"
  }
}

resource "aws_subnet" "Omega_vpcpupSN" {
  vpc_id            = aws_vpc.Omega_vpc.id
  cidr_block        = var.subnet_cidrs.keycidr[0]
  availability_zone = var.availability_zones.keyzone[0]

  tags = {
    Name = "Omega_vpcpupSN"
  }
}

resource "aws_subnet" "Omega_vpcpriSN" {
  vpc_id            = aws_vpc.Omega_vpc.id
  cidr_block        = var.subnet_cidrs.keycidr[1]
  availability_zone = var.availability_zones.keyzone[1]
  tags = {
    Name = "Omega_vpcpriSN"
  }
}

resource "aws_route_table" "omega-pupRT" {
  vpc_id = aws_vpc.Omega_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Omega-igw.id
  }
  tags = {
    Name = "Omega-pupRT"
  }
}

resource "aws_route_table" "omega-pripRT" {
  vpc_id = aws_vpc.Omega_vpc.id
  tags = {
    Name = "omega-pripRT"
  }
}

resource "aws_route_table_association" "omega-pupRTASS" {
  subnet_id      = aws_subnet.Omega_vpcpupSN.id
  route_table_id = aws_route_table.omega-pupRT.id
}

resource "aws_route_table_association" "omega-pripRTASS" {
  subnet_id      = aws_subnet.Omega_vpcpriSN.id
  route_table_id = aws_route_table.omega-pripRT.id
}

resource "aws_security_group" "Omega-webSG-allow_tls" {
  name        = "Omega-webSGallow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.Omega_vpc.id

  ingress {
    description = "TLS from https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.Omega_vpc.cidr_block]
  }
  ingress {
    description = "TLS from SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from hppt"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Omega-webSGallow_tls"
  }
}
