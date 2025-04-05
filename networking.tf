resource "aws_vpc" "application" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "application"
  }
}


resource "aws_internet_gateway" "application-gw" {
  vpc_id = aws_vpc.application.id
  tags = {
    Name = "application-gw"
  }
}

# Creating a public subnet in the VPC

resource "aws_subnet" "public_subnet-1" {
  vpc_id                  = aws_vpc.application.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 1 for Application"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.application.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.application-gw.id
  }

  tags = {
    Name = "Public Route Table for Application"
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet-1.id
  route_table_id = aws_route_table.public.id
}

# Adding a second public subnet in a different availability zone

resource "aws_subnet" "public_subnet-2" {
  vpc_id                  = aws_vpc.application.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 2 for Application"
  }

}

resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_subnet-2.id
  route_table_id = aws_route_table.public.id
}

# Creating a private subnet in the VPC

resource "aws_subnet" "private_subnet-1" {
  vpc_id                  = aws_vpc.application.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet 1 for Application"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet-1.id

  tags = {
    Name = "NAT Gateway for Application"
  }

}
# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  associate_with_private_ip = "10.0.3.1"
}


# private route table for private subnets

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.application.id

  route {
    cidr_block     = "0.0.0.0/24"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    "Name" = "Private Route Table for Application"
  }
}

resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet-1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_subnet" "private_subnet-2" {
  vpc_id                  = aws_vpc.application.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet 2 for Application"
  }
}

resource "aws_route_table_association" "private_association_2" {
  subnet_id      = aws_subnet.private_subnet-2.id
  route_table_id = aws_route_table.private_rt.id
}