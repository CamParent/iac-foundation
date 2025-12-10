# ==============================
# Hub VPC Subnets
# ==============================

resource "aws_subnet" "private_a_1" {
  vpc_id                  = aws_vpc.hub.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "hub-private-a-1"
  }
}

resource "aws_subnet" "private_a_2" {
  vpc_id                  = aws_vpc.hub.id
  cidr_block              = "10.0.128.0/20"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "hub-private-a-2"
  }
}

resource "aws_subnet" "private_b_1" {
  vpc_id                  = aws_vpc.hub.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "hub-private-b-1"
  }
}

resource "aws_subnet" "private_b_2" {
  vpc_id                  = aws_vpc.hub.id
  cidr_block              = "10.0.144.0/20"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "hub-private-b-2"
  }
}

# ==============================
# Spoke VPC Subnets
# ==============================

# Spoke public subnet - us-east-2a
resource "aws_subnet" "spoke_public_a" {
  vpc_id                  = aws_vpc.spoke.id
  cidr_block              = "10.1.0.0/20"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "spoke-subnet-public1-us-east-2a"
  }
}

# Spoke public subnet - us-east-2b
resource "aws_subnet" "spoke_public_b" {
  vpc_id                  = aws_vpc.spoke.id
  cidr_block              = "10.1.16.0/20"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "spoke-subnet-public2-us-east-2b"
  }
}

# Spoke private subnet - us-east-2a
resource "aws_subnet" "spoke_private_a" {
  vpc_id                  = aws_vpc.spoke.id
  cidr_block              = "10.1.128.0/20" # match existing subnet-083a703aa2dd2f907
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "spoke-subnet-private1-us-east-2a"
  }
}

# Spoke private subnet - us-east-2b
resource "aws_subnet" "spoke_private_b" {
  vpc_id                  = aws_vpc.spoke.id
  cidr_block              = "10.1.144.0/20" # match existing subnet-0790938f9626438b1
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "spoke-subnet-private2-us-east-2b"
  }
}
