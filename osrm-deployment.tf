resource "kubernetes_deployment" "osrm_deployment" {
  metadata {
    name = "osrm-deployment"
    labels = {
      app = "osrm"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "osrm"
      }
    }

    template {
      metadata {
        labels = {
          app = "osrm"
        }
      }

      spec {
        container {
          image = "461295571172.dkr.ecr.us-east-1.amazonaws.com/devops-assessment/osrm:latest"
          name  = "osrm"

          port {
            container_port = 5000
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }

            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 5000
            }

            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 5000
            }

            initial_delay_seconds = 10
            period_seconds        = 5
          }
        }
      }
    }
  }
}
