# =============================
# HUB VPC ENDPOINTS
# =============================

# -------------------------------
# S3 Gateway Endpoint (HUB)
# -------------------------------
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.hub.id
  service_name      = "com.amazonaws.us-east-2.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.hub_private_a.id,
    aws_route_table.hub_private_b.id
  ]

  tags = {
    Name = "hub-vpce-s3"
  }

  lifecycle {
    ignore_changes = [route_table_ids]
  }
}

# -------------------------------
# SSM Interface Endpoint (HUB)
# -------------------------------
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.hub.id
  service_name      = "com.amazonaws.us-east-2.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private_b_2.id, # subnet-0a8d0a28712771b8a
    aws_subnet.private_a_2.id  # subnet-0e3affbce0558c35f
  ]

  security_group_ids = [
    "sg-09ad523c5a6572a0c"
  ]

  private_dns_enabled = true
}

# -------------------------------
# SSMMessages Interface Endpoint (HUB)
# -------------------------------
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.hub.id
  service_name      = "com.amazonaws.us-east-2.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private_b_2.id,
    aws_subnet.private_a_2.id
  ]

  security_group_ids = [
    "sg-09ad523c5a6572a0c"
  ]

  private_dns_enabled = true
}

# -------------------------------
# EC2Messages Interface Endpoint (HUB)
# -------------------------------
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.hub.id
  service_name      = "com.amazonaws.us-east-2.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private_b_2.id,
    aws_subnet.private_a_2.id
  ]

  security_group_ids = [
    "sg-09ad523c5a6572a0c"
  ]

  private_dns_enabled = true
}

# =============================
# SPOKE VPC ENDPOINTS
# =============================

# S3 Gateway Endpoint (SPOKE)
resource "aws_vpc_endpoint" "spoke_s3" {
  vpc_id            = aws_vpc.spoke.id
  service_name      = "com.amazonaws.us-east-2.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.spoke_private_a.id,
    aws_route_table.spoke_private_b.id,
  ]

  tags = {
    Name = "spoke-vpce-s3"
  }

  lifecycle {
    ignore_changes = [route_table_ids]
  }
}
