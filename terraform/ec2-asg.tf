resource "aws_launch_template" "app" {
  name_prefix   = "${local.common_name}-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    repository      = local.repository
    db_host_b64     = base64encode(aws_db_instance.main.address)
    db_user_b64     = base64encode(var.db_username)
    db_password_b64 = base64encode(var.db_password)
    db_name_b64     = base64encode(var.db_name)
    db_port_b64     = base64encode(tostring(aws_db_instance.main.port))
  }))

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "${local.common_name}-app" }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  name                      = "${local.common_name}-asg"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = aws_subnet.public[*].id
  target_group_arns         = [aws_lb_target_group.app.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}

resource "aws_autoscaling_policy" "cpu_target" {
  name                   = "${local.common_name}-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60
  }
}
