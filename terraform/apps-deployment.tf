resource "kubernetes_deployment" "nginx" {
  metadata { name = "nginx" }
  spec {
    replicas = var.nginx_replicas
    selector { 
      match_labels = { 
        app = "nginx" 
        } 
      }
    template {
      metadata { 
        labels = { 
          app = "nginx" 
        } 
      }
      spec {
        container { 
          name="nginx"
          image="nginx:latest"
          ports {
            container_port=80
          } 
        }
      }
    }
  }
}

resource "kubernetes_deployment" "nodejs" {
  metadata { 
    name = "nodejs-app" 
    }
  spec {
    replicas = var.nodejs_replicas
    selector { 
      match_labels = { 
        app = "nodejs-app" 
        } 
      }
    template {
      metadata { 
        labels = { 
          app = "nodejs-app" 
        } 
      }
      spec {
        container { 
          name="nodejs-app"
          image=var.nodejs_docker_image
          ports{
            container_port=3000
          } 
        }
      }
    }
  }
}

resource "kubernetes_deployment" "k8sgpt" {
  metadata { 
    name="k8sgpt"
    namespace="k8sgpt"
  }
  spec {
    replicas = var.k8sgpt_replicas
    selector { 
      match_labels= {
        app="k8sgpt"
      } 
    }
    template {
      metadata { 
        labels= {
          app="k8sgpt"
        } 
      }
      spec {
        container { 
          name="k8sgpt"
          image="ghcr.io/k8sgpt-ai/k8sgpt:latest"
          ports {
            container_port=80
          } 
        }
      }
    }
  }
}
