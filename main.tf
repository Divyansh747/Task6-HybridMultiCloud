provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}

resource "aws_db_instance" "rds" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.30"
  instance_class       = "db.t2.micro"
  name                 = "wordpress"
  username             = "wordpress"
  password             = "wordpress"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = "true"
  port                 = "3306"
}
