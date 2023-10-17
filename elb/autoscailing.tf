# configure
resource "aws_launch_configuration" "launchconfig" {
  name          = "launch-config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mykeypair.key_name
  security_groups = [
      aws_security_group.myinstance.id
  ]

  user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'this is: '$MYIP > /var/www/html/index.html"
  
  lifecycle {
    create_before_destroy = true
  }
}

# auto scailing group
resource "aws_autoscaling_group" "autoscailing-group" {
  name = "autoscaling group"
  
  vpc_zone_identifier = [
      # 서브넷 2개 지정
      aws_subnet.main-public-1, 
      aws_subnet.main-public-2
  ]

  launch_configuration = aws_launch_configuration.launchconfig.name
 
  min_size           = 2
  max_size           = 2 

  health_check_type = "ELB" # ELB지정
  load_balancers = [
      aws_elb.my_elb.name # load balancer 지정
  ]
  health_check_grace_period = 300
  force_delete = true 
}