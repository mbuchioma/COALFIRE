resource "aws_launch_template" "lt" {
  name                   = "${var.project}-LT"
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg-ec2.id]
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/sdg"
    ebs {
      volume_size = var.block_volume
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name                = "${var.project}-ec2"
    }
  }

  user_data = base64encode(data.template_file.user_data.rendered)
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.project}-asg"
  vpc_zone_identifier       = var.lb_subnets
  min_size                  = var.min_size #min size serve as the desired capacity
  max_size                  = var.max_size
  health_check_grace_period = var.healthcheck_period
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest" 
  }

  instance_refresh {  //This updates the ASG with the latest version of the LT
    strategy = "Rolling"
    preferences {}
  }

  lifecycle {
    create_before_destroy = true
  }

  target_group_arns = [
    var.target_group_arns
  ]

  dynamic "tag" {
    for_each = data.aws_default_tags.asg.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}