# -------------------------------
# Hub VPC Attachment
# -------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  transit_gateway_id = aws_ec2_transit_gateway.lab.id
  vpc_id             = aws_vpc.hub.id

  subnet_ids = [
    "subnet-0a8d0a28712771b8a",
    "subnet-0e3affbce0558c35f"
  ]

  tags = {
    Name = "hub-attachment"
  }
}

# -------------------------------
# Spoke VPC Attachment
# -------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  transit_gateway_id = aws_ec2_transit_gateway.lab.id
  vpc_id             = "vpc-0b8c9a07a756ff06b"

  # We will not import spoke subnets yet
  subnet_ids = [
    "subnet-placeholder-a",
    "subnet-placeholder-b"
  ]

  tags = {
    Name = "spoke-attachment"
  }

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}
