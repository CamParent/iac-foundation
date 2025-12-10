#####################################
# HUB INTERNET GATEWAY
#####################################

resource "aws_internet_gateway" "hub" {
  vpc_id = aws_vpc.hub.id

  tags = {
    Name = "hub-igw"
  }
}

#####################################
# SPOKE INTERNET GATEWAY
#####################################

resource "aws_internet_gateway" "spoke" {
  vpc_id = aws_vpc.spoke.id

  tags = {
    Name = "spoke-igw"
  }
}
