// ALB for Spoke VPC
resource "aws_eip" "alb_eip_az1" {
}

resource "aws_eip" "alb_eip_az2" {
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.cp}-${var.env}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.vpc-main.vpc_id

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ var.myip ]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "public_alb" {
  name               = "${var.cp}-${var.env}-public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [module.subnet-public-az1.id, module.subnet-public-az2.id]
  enable_deletion_protection = false
}

resource "aws_acm_certificate" "alb_public_cert" {
  domain_name       = "${var.alb_certificate_endpoint_name}.${var.alb_certificate_domain_name}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "alb_zone" {
  name         = "${var.alb_certificate_domain_name}."
  private_zone = false
}

resource "aws_route53_record" "alb_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.alb_public_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  zone_id = data.aws_route53_zone.alb_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "alb_cert_validation" {
  certificate_arn         = aws_acm_certificate.alb_public_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.alb_cert_validation : record.fqdn]
}

resource "aws_lb_target_group" "alb_tg_https" {
  name     = "${var.cp}-${var.env}-alb-tg-https"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = module.vpc-main.vpc_id
  health_check {
    path                = "/index.html"
    protocol            = "HTTPS"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb_target_group_attachment" "alb_tg_https_az1" {
  depends_on = [module.linux-instance-az1]
  target_group_arn = aws_lb_target_group.alb_tg_https.arn
  target_id        = module.linux-instance-az1.instance_id
  port             = 443
}

resource "aws_lb_target_group_attachment" "alb_tg_https_az2" {
  depends_on = [module.linux-instance-az2]
  target_group_arn = aws_lb_target_group.alb_tg_https.arn
  target_id        = module.linux-instance-az2.instance_id
  port             = 443
}

resource "aws_route53_record" "alb_a_record" {
  zone_id = data.aws_route53_zone.alb_zone.zone_id
  name    = var.alb_certificate_endpoint_name
  type    = "A"
  alias {
    name                   = aws_lb.public_alb.dns_name
    zone_id                = aws_lb.public_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_lb_listener" "alb_https" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.alb_cert_validation.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_https.arn
  }
}

resource "aws_route53_record" "linux_east_az1" {
  zone_id = data.aws_route53_zone.alb_zone.zone_id
  name    = "linux-east-az1.${var.alb_certificate_domain_name}"
  type    = "A"
  ttl     = 300
  records = [element(module.linux-instance-az1.public_eip, 0)]
}

resource "aws_route53_record" "linux_east_az2" {
  zone_id = data.aws_route53_zone.alb_zone.zone_id
  name    = "linux-east-az2.${var.alb_certificate_domain_name}"
  type    = "A"
  ttl     = 300
  records = [element(module.linux-instance-az2.public_eip, 0)]
}
