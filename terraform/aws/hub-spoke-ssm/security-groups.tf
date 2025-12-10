# ==============================
# Security Groups (Imported + Rules)
# ==============================

# ------------------------------
# Default VPC SG (HUB)
# ------------------------------
resource "aws_security_group" "default" {
  name        = "default"
  description = "default VPC security group"
  vpc_id      = aws_vpc.hub.id

  # Ingress: allow all traffic from self
  ingress {
    description = ""
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Egress: allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  revoke_rules_on_delete = false
}

# ------------------------------
# Launch Wizard SG (temp EC2 / HUB)
# ------------------------------
resource "aws_security_group" "launch_wizard" {
  name        = "launch-wizard-1"
  description = "launch-wizard-1 created 2025-12-09T21:37:31.523Z"
  vpc_id      = aws_vpc.hub.id

  # Ingress: SSH from your public IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["76.34.82.77/32"]
  }

  # Ingress: ICMP (all types) from 10.0.0.0/16
  ingress {
    description = "Allow internal ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Egress: allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  revoke_rules_on_delete = false
}

# ------------------------------
# SSM VPC Interface Endpoints SG (HUB)
# ------------------------------
resource "aws_security_group" "ssm_endpoints" {
  name        = "hub-ssm-endpoints-sg"
  description = "SSM interface endpoints"
  vpc_id      = aws_vpc.hub.id

  # Ingress: HTTPS from inside 10.0.0.0/16
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Egress: allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  revoke_rules_on_delete = false
}

# ------------------------------
# ICMP Lab SG (Hub <-> Spoke)
# ------------------------------
resource "aws_security_group" "lab_icmp" {
  name        = "lab-icmp-sg"
  description = "Allow ICMP between hub and spoke"
  vpc_id      = aws_vpc.hub.id

  # Ingress: ICMP (all types) from hub + spoke CIDR ranges
  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks = [
      "10.0.0.0/16", # hub
      "10.1.0.0/16", # spoke
    ]
  }

  # Egress: allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  revoke_rules_on_delete = false
}

# ==============================
# SPOKE SECURITY GROUPS
# ==============================

# ICMP SG in spoke VPC
resource "aws_security_group" "spoke_icmp" {
  name        = "spoke-icmp-sg"
  description = "Allow ICMP between spoke and hub"
  vpc_id      = aws_vpc.spoke.id

  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks = [
      "10.0.0.0/16",
      "10.1.0.0/16",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  revoke_rules_on_delete = false
}

# Default SG for spoke VPC
resource "aws_security_group" "spoke_default" {
  name        = "default"
  description = "default VPC security group" # must match AWS exactly
  vpc_id      = aws_vpc.spoke.id

  ingress {
    description = ""
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  revoke_rules_on_delete = false
}
