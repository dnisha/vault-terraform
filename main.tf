resource "aws_iam_role" "bastian_instance_role" {
  name = "bastian-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "bastian_instance_role_attachment" {
  name = "ec2-ansible-role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  roles = [aws_iam_role.bastian_instance_role.name]
}

resource "aws_iam_instance_profile" "bastian_profile" {
  name = "bastian_profile"
  role = "${aws_iam_role.bastian_instance_role.name}"
}

resource "aws_iam_role" "vault_instance_role" {
  name = "vault-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "vault_instance_role_attachment" {
  name = "ec2-vault-role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  roles = [aws_iam_role.vault_instance_role.name]
}

resource "aws_iam_policy_attachment" "kms_policy_attachment" {
  name       = "kms-vault-role"
  policy_arn = "arn:aws:iam::aws:policy/service-role/ROSAKMSProviderPolicy"
  roles      = [aws_iam_role.vault_instance_role.name]
}

resource "aws_iam_instance_profile" "vault_profile" {
  name = "vault_profile"
  role = "${aws_iam_role.vault_instance_role.name}"
}

resource "aws_iam_policy" "console_ec2_discovery_policy" {
  name        = "console-ec2-discovery-policy"
  description = "Policy for HashiCorp Console EC2 discovery"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeTags",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_role" "console_instance_role" {
  name = "console-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "console_instance_role_attachment" {
  name       = "console-ec2-discovery-attachment"
  policy_arn = aws_iam_policy.console_ec2_discovery_policy.arn
  roles      = [aws_iam_role.console_instance_role.name]
}

resource "aws_iam_instance_profile" "console_profile" {
  name = "console_profile"
  role = "${aws_iam_role.console_instance_role.name}"
}

# resource "aws_instance" "example_instance" {
#   ami           = "ami-0f5ee92e2d63afc18"  
#   instance_type = "t2.micro"              
  
#   iam_instance_profile = aws_iam_instance_profile.console_profile.name
# }