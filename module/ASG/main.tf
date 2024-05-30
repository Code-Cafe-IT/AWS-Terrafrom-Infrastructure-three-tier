resource "aws_autoscaling_group" "tf_asg" {
  name = "tf-asg"
  max_size = 3
  min_size = 1
  desired_capacity = 2
  depends_on = [ var.load_balancers, aws_lb_target_group.tf-tgroups  ]
  target_group_arns = [ "${aws_lb_target_group.tf-tgroups.arn}" ]
  health_check_type = "EC2"
  launch_template {
    id = aws_launch_template.tf_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = [ "${var.public_subnet_1a}", "${var.public_subnet_1b}", "${var.public_subnet_1c}" ]

  tag {
    key = "Name"
    value = "${var.project_name}-tf-autoscaling-groups"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "tf_template" {
  name_prefix = "${var.project_name}-tf-template"
  image_id = var.image_id
  key_name = "Nat-sing"
  instance_type = "t2.small"
}

resource "aws_lb_target_group" "tf-tgroups" {
  name = "${var.project_name}tf-tgroups"
  depends_on = [ var.vpc_cidr ]
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_cidr
  health_check {
    path = "/"
    matcher = "200"
    interval = 15
    timeout = 2
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}
