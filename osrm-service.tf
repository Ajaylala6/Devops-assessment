resource "kubernetes_service" "osrm_service" {
  metadata {
    name = "osrm-service"
  }

  spec {
    selector = {
      app = "osrm"
    }

    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}
