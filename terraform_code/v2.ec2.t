provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "demo" {
ami = "ami-0d682f26195e9ec0f"
instance_type = "t2.micro"
key_name =  "Project1"
security_groups =["demo-sg"]
}


resource "aws_security_group" "demo-sg" {

    name = "demo-sg"
    description = "Allow TLS inbound traffic"

   

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


