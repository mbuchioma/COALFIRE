#Bastion Host
resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  //vpc_id = var.vpc_id
  subnet_id   = var.subnet_id
  // key-pair generated in the aws console
  key_name = var.key_name
  security_groups  = [aws_security_group.bastion-sg.id]

  ebs_block_device {
    device_name  = "/dev/sdf"
    volume_size = var.bastion_volume_size
  }

  tags = {
    Name = "bastion-server"
  }
}

