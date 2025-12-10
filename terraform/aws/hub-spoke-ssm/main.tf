# ==============================
# Hub VPC
# ==============================
resource "aws_vpc" "hub" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "hub-vpc"
    Role = "hub"
  }
}

# ==============================
# Spoke VPC
# ==============================
resource "aws_vpc" "spoke" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "spoke-vpc"
    Role = "spoke"
  }
}
