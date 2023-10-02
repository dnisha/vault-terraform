resource "aws_lb_target_group" "vault_tg" {
  name        = "vault-group"
  port        = 8200
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 30
    port                = 8200
    protocol            = "HTTP"
    path                = "/v1/sys/health?uninitcode=200"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "example" {
  count            = length(var.vault_instance)
  target_group_arn = aws_lb_target_group.vault_tg.arn
  target_id        = var.vault_instance[count.index].id
}

resource "aws_lb" "vault_lb" {
  name                       = "vault-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = var.alb_subnet_list
  security_groups            = var.public_sg_list
  enable_deletion_protection = false
}

resource "aws_lb_listener" "vault_lb_lustner" {
  load_balancer_arn = aws_lb.vault_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault_tg.arn
  }
}

resource "aws_launch_configuration" "vault_lc" {
  name_prefix   = "vault-lc"
  image_id      = var.vault_ami
  instance_type = "t2.micro"
  iam_instance_profile = "vault_profile"
  security_groups             = var.vault_sg_list
  key_name                    = "gone-servers"
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "vault_asg" {
  name                 = "vault-asg"
  min_size             = 2
  max_size             = 2
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.vault_lc.name
  vpc_zone_identifier  = var.vault_subnet_list

  target_group_arns = [aws_lb_target_group.vault_tg.arn]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Tool"
    value               = "vault"
    propagate_at_launch = true
  }

}
