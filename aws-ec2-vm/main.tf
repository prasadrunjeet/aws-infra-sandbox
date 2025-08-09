# --------------------------
# Security Group
# --------------------------
resource "aws_security_group" "vm_sg" {
  name        = "${var.instance_name}-sg"
  description = "Security group for ${var.instance_name}"
  vpc_id      = var.vpc_id

  # Example inbound rules
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic allowed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name}-sg"
    Env  = var.environment
  }
}

# --------------------------
# EC2 Instance with Root Disk
# --------------------------
resource "aws_instance" "vm" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.vm_sg.id]

  # Root volume config
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
    encrypted = true
  }

  tags = {
    Name = var.instance_name
    Env  = var.environment
  }
}

# --------------------------
# Elastic IP
# --------------------------
resource "aws_eip" "vm_eip" {
  instance = aws_instance.vm.id
  domain   = "vpc"  # Needed for VPC-based instances
  tags = {
    Name = "${var.instance_name}-eip"
    Env  = var.environment
  }
}
