# Provider Configuration
provider "aws" {
  region = "ap-south-1"
}

# Create EC2 Instance
resource "aws_instance" "demo" {
ami = "ami-0d682f26195e9ec0f"
instance_type = "t2.micro"
key_name =  "Project1"
subnet_id = aws_subnet.my-subnet-1.id
vpc_security_group_ids = [aws_security_group.demo-sg.id]
associate_public_ip_address = true
}

#  Create Security Group (for EC2)
resource "aws_security_group" "demo-sg" {

    name = "demo-sg"
    description = "Allow TLS inbound traffic"
    vpc_id = aws_vpc.main.id

   

ingress  {
    description = "ssh access"
    from_port=22
    to_port=22
    protocol="tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

egress {
    from_port = 0
    to_port = 0
    protocol = -1 // Applies to all protocols (-1 means all IP protocols, including TCP, UDP, ICMP, etc.)
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = ["::/0"]

}
tags = {
  Name="ssh"
}

}

# Create VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
  
  tags={
    Name="my-vpc"
  }
}


# Create Subnet 1
resource "aws_subnet" "my-subnet-1" {
 vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
    
    tags = {
      Name="my-vpc-subnet-1"
    }
  
}

# Create Subnet 2
resource "aws_subnet" "my-subnet-2" {
 vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1b"
    
    tags = {
      Name="my-vpc-subnet-2"
    }
  
}

#  Create Internet Gateway
resource "aws_internet_gateway" "my-igw" {

     vpc_id = aws_vpc.main.id
    tags = {
        Name="my-igw"
    }
}

# Create Route Table
resource "aws_route_table" "my-public-rt" {
  
   vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }

}

# Associate Route Table with Subnet 1
resource "aws_route_table_association" "my-public-subnet-1" {
    subnet_id = aws_subnet.my-subnet-1.id
    route_table_id = aws_route_table.my-public-rt.id
}


# Associate Route Table with Subnet 2
resource "aws_route_table_association" "my-public-subnet-2" {
    subnet_id = aws_subnet.my-subnet-2.id
    route_table_id = aws_route_table.my-public-rt.id
}



