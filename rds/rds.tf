# 서브넷 그룹 생성
resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-db-subnet"
  
  # 서브넷 그룹에 포함할 서브넷 지정
  # RDS 데이터베이스 인스턴스가 이 서브넷 그룹에 속한 서브넷 중 하나에 배치
  subnet_ids = [
      aws_subnet.main-private-1.id, aws_subnet.main-private-2.id
  ]
}

# 파라미터 그룹 생성
resource "aws_db_parameter_group" "main" {
  name   = "${var.env}-db-param-group"
  family = "mysql5.6"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
}

# RDS 생성
resource "aws_db_instance" "main" {
  allocated_storage       = 100
  db_name                 = "mydb"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  
  username                = var.rds_user_name
  password                = var.rds_password
  
  parameter_group_name    = aws_db_parameter_group.main.name
  db_subnet_group_name    = aws_db_subnet_group.main.name
  
  multi_az                = false
  
  vpc_security_group_ids  = [ 
      aws_security_group.allow_mysql.id
  ]
  storage_type            =   "gp2"
  backup_retention_period = 30 
}