# Create VPC
resource "aws_vpc" "tf_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
  tags = {
    Name = "${var.project_name}-tf-vpc"
  }
}
# Create Subnet 

data "aws_availability_zones" "aws_availability_zones" {
  state = "available"
}

resource "aws_subnet" "tf_public_subnet_us_east_1a" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.public_subnet_1a
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-tf-public-subnet-1a"
  }
}

resource "aws_subnet" "tf_public_subnet_us_east_1b" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.public_subnet_1b
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[1]
  tags = {
    Name = "${var.project_name}-tf-public-subnet-1b"
  }
}

resource "aws_subnet" "tf_public_subnet_us_east_1c" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.public_subnet_1c
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[2]
  tags = {
    Name = "${var.project_name}-tf-public-subnet-1c"
  }
}

resource "aws_subnet" "tf_private_subnet_us_east_1a" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.private_subnet_1a
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[0]
  tags = {
    Name = "${var.project_name}-tf-private-subnet-1a"
  }
}

resource "aws_subnet" "tf_private_subnet_us_east_1b" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.private_subnet_1b
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[1]
  tags = {
    Name = "${var.project_name}-tf-private-subnet-1b"
  }
}

resource "aws_subnet" "tf_private_subnet_us_east_1c" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.private_subnet_1c
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[2]
  tags = {
    Name = "${var.project_name}-tf-private-subnet-1c"
  }
}

#Create InternetGateway
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
}

#Create NAT

resource "aws_eip" "tf_eip_1a" {
  domain = "vpc"
}

resource "aws_eip" "tf_eip_1b" {
  domain = "vpc"
}

resource "aws_eip" "tf_eip_1c" {
  domain = "vpc"
}

resource "aws_nat_gateway" "tf_nat_1a" {
  allocation_id = aws_eip.tf_eip_1a.id
  subnet_id = aws_subnet.tf_public_subnet_us_east_1a.id
  depends_on = [ aws_internet_gateway.tf_igw ]
}

resource "aws_nat_gateway" "tf_nat_1b" {
  allocation_id = aws_eip.tf_eip_1b.id
  subnet_id = aws_subnet.tf_public_subnet_us_east_1b.id
  depends_on = [ aws_internet_gateway.tf_igw ]
}
resource "aws_nat_gateway" "tf_nat_1c" {
  allocation_id = aws_eip.tf_eip_1c.id
  subnet_id = aws_subnet.tf_public_subnet_us_east_1c.id
  depends_on = [ aws_internet_gateway.tf_igw ]
}

#Create routable

resource "aws_route_table" "tf_public_rtb" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
  tags = {
    Name = "${var.project_name}-tf-public-rtb"
  }
}

resource "aws_route_table" "tf_private_rtb_1a" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf_nat_1a.id
  }
  tags = {
    Name = "${var.project_name}-tf-private-rtb-1a"
  }
}

resource "aws_route_table" "tf_private_rtb_1b" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf_nat_1b.id
  }
  tags = {
    Name = "${var.project_name}-tf-private-rtb-1b"
  }
}

resource "aws_route_table" "tf_private_rtb_1c" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf_nat_1c.id
  }
  tags = {
    Name = "${var.project_name}-tf-private-rtb-1c"
  }
}

#Attach Routetable

resource "aws_route_table_association" "tf_att_public_rtb_1a" {
  route_table_id = aws_route_table.tf_public_rtb.id
  subnet_id = aws_subnet.tf_public_subnet_us_east_1a.id
}

resource "aws_route_table_association" "tf_att_public_rtb_1b" {
  route_table_id = aws_route_table.tf_public_rtb.id
  subnet_id = aws_subnet.tf_public_subnet_us_east_1b.id
}

resource "aws_route_table_association" "tf_att_public_rtb_1c" {
  route_table_id = aws_route_table.tf_public_rtb.id
  subnet_id = aws_subnet.tf_public_subnet_us_east_1c.id
}

resource "aws_route_table_association" "tf_att_private_rtb_1a" {
  route_table_id = aws_route_table.tf_private_rtb_1a.id
  subnet_id = aws_subnet.tf_private_subnet_us_east_1a.id
}

resource "aws_route_table_association" "tf_att_private_rtb_1b" {
  route_table_id = aws_route_table.tf_private_rtb_1b.id
  subnet_id = aws_subnet.tf_private_subnet_us_east_1b.id
}

resource "aws_route_table_association" "tf_att_private_rtb_1c" {
  route_table_id = aws_route_table.tf_private_rtb_1c.id
  subnet_id = aws_subnet.tf_private_subnet_us_east_1c.id
}

#Create Security Group



data "http" "my_ip" {
  url = "http://checkip.amazonaws.com"
}

resource "aws_security_group" "tf_sg_alb" {
  vpc_id = aws_vpc.tf_vpc.id
  name = "tf-sg-alb"
  description = "Allow HTTP inbound traffic"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-tf-sg-alb"
  }
}

resource "aws_security_group" "tf_sg_asg" {
    name = "tf-sg-asg"
    description = "Allow SSH inbound traffic form my IP, HTTP form ALB"
  vpc_id = aws_vpc.tf_vpc.id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = [ aws_security_group.tf_sg_alb.id ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-tf-sg-asg"
  }
}

resource "aws_security_group" "tf_sg_rds" {
    name = "tf-sg-rds"
    description = "Allow port 3306 My SQL"
  vpc_id = aws_vpc.tf_vpc.id
  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    security_groups = [ aws_security_group.tf_sg_asg.id ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-tf-sg-rds"
  }
}





