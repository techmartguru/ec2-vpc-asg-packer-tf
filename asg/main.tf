provider "aws" {
  region = "us-east-1"
}

######
# Launch configuration and autoscaling group
######
module "asg" {
  source = "../module"

  name = "asg-elb"

  # Launch configuration
  lc_name = "consumer-lc"

  image_id        = "ami-0ba960472fc891755"
  instance_type   = "t2.micro"
  security_groups = ["sg-0b61afc3e2209e3fa"]
  key_name        = "test-project"
  associate_public_ip_address = "false"


  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "10"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "10"
      volume_type = "gp2"
    },
  ]



  # Auto scaling group
  asg_name                  = "web-asg"
  vpc_zone_identifier       = ["subnet-07e4c267181e8627a","subnet-0e116b283ee65d153"]
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 4
  desired_capacity          = 1
  wait_for_capacity_timeout = 0


  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    }
  ]

  #Auto-Scaling Policy-Scale-up
  auto-scaling-policy-name-scale-up = "cpu-policy-scale-up"
  adjustment-type-scale-up = "ChangeInCapacity"
  scaling-adjustment-scale-up = "1"
  cooldown-scale-up = "300"
  policy-type-scale-up = "SimpleScaling"

  #Auto-Scaling Policy Cloud-Watch Alarm-Scale-Up
  alarm-name-scale-up = "cpu-alarm-scale-up"
  comparison-operator-scale-up = "GreaterThanOrEqualToThreshold"
  evaluation-periods-scale-up = "2"
  metric-name-scale-up = "CPUUtilization"
  namespace-scale-up = "AWS/EC2"
  period-scale-up = "120"
  statistic-scale-up = "Average"
  threshold-scale-up = "70"

  #Auto-Scaling Policy-Scale-down
  auto-scaling-policy-name-scale-down = "cpu-policy-scale-down"
  adjustment-type-scale-down = "ChangeInCapacity"
  scaling-adjustment-scale-down = "-1"
  cooldown-scale-down = "300"
  policy-type-scale-down = "SimpleScaling"

  #Auto-Scaling Policy Cloud-Watch Alarm-Scale-down
  alarm-name-scale-down = "cpu-alarm-scale-down"
  comparison-operator-scale-down = "LessThanOrEqualToThreshold"
  evaluation-periods-scale-down = "2"
  metric-name-scale-down = "CPUUtilization"
  namespace-scale-down = "AWS/EC2"
  period-scale-down = "120"
  statistic-scale-down = "Average"
  threshold-scale-down = "50"
}

