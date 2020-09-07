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

resource "kubernetes_deployment" "wordpress" {
depends_on = [aws_db_instance.rds]
  metadata {
    name = "wordpress"
    labels = {
      App = "wordpress"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "wordpress"
      }
    }
    template {
      metadata {
        labels = {
          App = "wordpress"
        }
      }
      spec {
        container {
          image = "wordpress"
          name  = "wordpress"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpress"
  }
  spec {
    selector = {
      App = kubernetes_deployment.wordpress.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
      node_port   = 30000
    }

    type = "NodePort"
  }
}
                                                                 36,1          36%

