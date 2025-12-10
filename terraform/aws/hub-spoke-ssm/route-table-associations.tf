# =============================
# HUB ROUTE TABLE ASSOCIATIONS
# =============================

# hub-rtb-public associations
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.private_a_1.id
  route_table_id = aws_route_table.hub_public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.private_b_1.id
  route_table_id = aws_route_table.hub_public.id
}

# hub-rtb-private1-us-east-2a
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a_2.id
  route_table_id = aws_route_table.hub_private_a.id
}

# hub-rtb-private2-us-east-2b
resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b_2.id
  route_table_id = aws_route_table.hub_private_b.id
}

# =============================
# SPOKE ROUTE TABLE ASSOCIATIONS
# =============================

# NOTE: Map these to the real subnet IDs you imported:
#   - subnet-0c7eeabd1921de154
#   - subnet-0857c1073ab50fc87
#   - subnet-083a703aa2dd2f907
#   - subnet-0790938f9626438b1

resource "aws_route_table_association" "spoke_public_a" {
  subnet_id      = aws_subnet.spoke_public_a.id
  route_table_id = aws_route_table.spoke_public.id
}

resource "aws_route_table_association" "spoke_public_b" {
  subnet_id      = aws_subnet.spoke_public_b.id
  route_table_id = aws_route_table.spoke_public.id
}

resource "aws_route_table_association" "spoke_private_a" {
  subnet_id      = aws_subnet.spoke_private_a.id
  route_table_id = aws_route_table.spoke_private_a.id
}

resource "aws_route_table_association" "spoke_private_b" {
  subnet_id      = aws_subnet.spoke_private_b.id
  route_table_id = aws_route_table.spoke_private_b.id
}
