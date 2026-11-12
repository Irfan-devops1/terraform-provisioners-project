provider "aws" {
  region = "ap-south-1"     # Change to your preferred AWS region
}

variable "cidr" {
  default = "10.0.0.0/16"  # Change to your preferred VPC CIDR range

}

resource "aws_key_pair" "name" {
  key_name   = "irfan-key"                          # Change to your AWS key pair name
  public_key = file("${path.module}/pk-key.pub")    # Replace with the path to your own SSH public key file

}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr

  tags = {
    Name = "my-vpc"
  }

}


resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"        # Change according to your VPC CIDR range
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

}
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }

}
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id

}

resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP FROM VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                   # Allow public HTTP access
  }
  ingress {
    description = "For SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                  # For better security, replace with your public IP/32
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Web-Sg"
  }

}
resource "aws_instance" "server" {
  ami                    = "ami-0c7632fb77f35db43"  # Replace with a valid Ubuntu AMI ID for your AWS region
  instance_type          = "t3.micro"               # Change according to your requirements
  key_name               = aws_key_pair.name.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id
  tags = {
    Name = "EC2-Irfan-Instance"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/pk-key")     # Replace with the path to your own SSH private key file
    host        = self.public_ip
  }

  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "app.py"              # Replace with the path to your local file
    destination = "/home/ubuntu/app.py" # Replace with the path on the remote instance
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y python3-pip python3-venv",
      "cd /home/ubuntu",
      "python3 -m venv venv",
      "./venv/bin/pip install flask",
      "sudo nohup ./venv/bin/python app.py > app.log 2>&1 < /dev/null &"
    ]
  }
}



