data "aws_security_group" "default" {
  vpc_id = var.vpc_id
  name   = "default"
}

# ---------------------------------------------------------------------------- #
# role
# ---------------------------------------------------------------------------- #
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "bastion_role" {
  name               = format("%s-bastion-rule", var.name)
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "bastion_ssm_core" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = format("%s-bastion-profile", var.name)
  role = aws_iam_role.bastion_role.name
}

# ---------------------------------------------------------------------------- #
# instance
# ---------------------------------------------------------------------------- #
resource "aws_instance" "bastion" {
  ami                         = "ami-07f4cb4629342979c" // Ubuntu 18.04
  instance_type               = var.instance_type
  vpc_security_group_ids      = [data.aws_security_group.default.id]
  subnet_id                   = var.subnet_id
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name
  ebs_optimized               = true
  key_name                    = var.key_name
  associate_public_ip_address = false

  user_data = templatefile(
    "${path.module}/user_data.sh",
    {
      upstream_map = var.upstream_map
      email        = var.email
    },
  )

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
  }

  tags        = merge(map("Name", format("%s-bastion", var.name)), var.tags)
  volume_tags = merge(map("Name", format("%s-bastion", var.name)), var.tags)
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
  tags     = merge(map("Name", format("%s-bastion", var.name)), var.tags)
}