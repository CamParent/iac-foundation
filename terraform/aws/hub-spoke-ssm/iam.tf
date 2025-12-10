# ==============================
# IAM for EC2 SSM Access
# ==============================

# EC2 role used for SSM
resource "aws_iam_role" "ec2_ssm_role" {
  name        = "ec2-ssm-role"
  path        = "/"
  description = "Allows EC2 instances to use AWS Systems Manager (Session Manager)"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Instance profile attached to EC2
resource "aws_iam_instance_profile" "ec2_ssm_role" {
  name = "ec2-ssm-role"
  path = "/"

  role = aws_iam_role.ec2_ssm_role.name
}
