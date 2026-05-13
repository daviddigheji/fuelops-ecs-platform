
# -----------------------------
# Application Load Balancer
# -----------------------------
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb"
    Project     = var.project_name
    Environment = var.environment
  }
}

# -----------------------------
# Target Group
# -----------------------------
# -----------------------------
# Target Group
# -----------------------------
resource "aws_lb_target_group" "app" {
  name        = "${var.project_name}-${var.environment}-tg-ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-tg-ip"
    Project     = var.project_name
    Environment = var.environment
  }
}


# -----------------------------
# ALB Listener
# -----------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
