# ==============================
# EC2 Instances (Hub / Spoke)
# ==============================

# Hub EC2 instance (Session Manager only)
resource "aws_instance" "hub_test" {
  ami           = "ami-00e428798e77d38d9"
  instance_type = "t3.micro"

  # This is subnet-0e3affbce0558c35f (hub-private-a-2)
  subnet_id = aws_subnet.private_a_2.id

  # Currently only in the SSM endpoints SG
  vpc_security_group_ids = [
    aws_security_group.ssm_endpoints.id,
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_role.name

  tags = {
    Name = "hub-test"
  }
}

# Spoke EC2 instance (for hub <-> spoke testing)
resource "aws_instance" "spoke_test" {
  # TODO: set this AMI to match your real spoke instance:
  # aws ec2 describe-instances --instance-ids i-0037e0d0a43f811fe ...
  ami           = "ami-00e428798e77d38d9" # placeholder; update if needed
  instance_type = "t3.micro"              # update if different

  # This should match subnet-083a703aa2dd2f907
  subnet_id = aws_subnet.spoke_private_a.id

  vpc_security_group_ids = [
    aws_security_group.spoke_icmp.id,
  ]

  associate_public_ip_address = false

  tags = {
    Name = "spoke-test"
  }

  lifecycle {
    ignore_changes = [
      user_data,
      user_data_base64,
    ]
  }
}
