provider "aws" {
  region = "ap-south-1"
}

variable "cidr" {
  default = "10.0.0.0/16"

}

resource "aws_key_pair" "name" {
  key_name   = "irfan-key"
  public_key = file("C:/Users/ecomadmin/Desktop/terraform-zero-to-hero/Day-5/pk-key.pub")

}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr

  tags = {
    Name = "my-vpc"
  }

}


resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
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
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "For SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "Web-Sg"
  }

}
resource "aws_instance" "server" {
  ami                    = "ami-0c7632fb77f35db43"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.name.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id
  tags = {
    Name = "EC2-Irfan-Instance"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/ecomadmin/Desktop/terraform-zero-to-hero/Day-5/pk-key")
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



