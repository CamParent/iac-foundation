# -------------------------------
# Public / Egress + TGW Route Table (HUB)
# -------------------------------
resource "aws_route_table" "hub_public" {
  vpc_id = aws_vpc.hub.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block         = "10.1.0.0/16"
    transit_gateway_id = "tgw-05c1af3193e435ed7"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hub.id
  }

  tags = {
    Name = "hub-rtb-public"
  }
}

# -------------------------------
# Private Route Table AZ-A (HUB)
# -------------------------------
resource "aws_route_table" "hub_private_a" {
  vpc_id = aws_vpc.hub.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block         = "10.1.0.0/16"
    transit_gateway_id = "tgw-05c1af3193e435ed7"
  }

  tags = {
    Name = "hub-rtb-private1-us-east-2a"
  }

  # S3 Gateway Endpoint injects AWS-managed
  # prefix-list routes that Terraform is NOT
  # allowed to modify.
  lifecycle {
    ignore_changes = [route]
  }
}

# -------------------------------
# Private Route Table AZ-B (HUB)
# -------------------------------
resource "aws_route_table" "hub_private_b" {
  vpc_id = aws_vpc.hub.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block         = "10.1.0.0/16"
    transit_gateway_id = "tgw-05c1af3193e435ed7"
  }

  tags = {
    Name = "hub-rtb-private2-us-east-2b"
  }

  lifecycle {
    ignore_changes = [route]
  }
}

# -------------------------------
# Main (Default) Route Table (HUB)
# -------------------------------
resource "aws_route_table" "hub_main" {
  vpc_id = aws_vpc.hub.id
}

# ======================================================
# SPOKE ROUTE TABLES
# ======================================================

# Public route table for spoke (Internet egress only)
resource "aws_route_table" "spoke_public" {
  vpc_id = aws_vpc.spoke.id

  route {
    cidr_block = "10.1.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.spoke.id
  }

  tags = {
    Name = "spoke-rtb-public"
  }
}

# Private RT AZ-A (spoke) – to hub via TGW + S3 endpoint
resource "aws_route_table" "spoke_private_a" {
  vpc_id = aws_vpc.spoke.id

  # Traffic to hub
  route {
    cidr_block         = "10.0.0.0/16"
    transit_gateway_id = "tgw-05c1af3193e435ed7"
  }

  # Local VPC
  route {
    cidr_block = "10.1.0.0/16"
    gateway_id = "local"
  }

  # S3 gateway endpoint injects prefix-list routes
  # Terraform should not try to manage those.
  lifecycle {
    ignore_changes = [route]
  }

  tags = {
    Name = "spoke-rtb-private1-us-east-2a"
  }
}

# Private RT AZ-B (spoke)
resource "aws_route_table" "spoke_private_b" {
  vpc_id = aws_vpc.spoke.id

  route {
    cidr_block         = "10.0.0.0/16"
    transit_gateway_id = "tgw-05c1af3193e435ed7"
  }

  route {
    cidr_block = "10.1.0.0/16"
    gateway_id = "local"
  }

  lifecycle {
    ignore_changes = [route]
  }

  tags = {
    Name = "spoke-rtb-private2-us-east-2b"
  }
}

# Main/default route table for spoke
resource "aws_route_table" "spoke_main" {
  vpc_id = aws_vpc.spoke.id
}
