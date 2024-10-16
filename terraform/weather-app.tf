provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.cluster.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_deployment" "weather_app" {
  metadata {
    name = "weather-app-deployment"
    labels = {
      app = "weather-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "weather-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "weather-app"
        }
      }

      spec {
        container {
          name  = "weather-app"
          image = "ranishstha/weather_app:latest"

          port {
            container_port = 8080
          }
        }
      }
    }
  }

  depends_on = [azurerm_kubernetes_cluster.cluster]
}

resource "kubernetes_service" "weather_app" {
  metadata {
    name = "weather-app-service"
  }

  spec {
    selector = {
      app = "weather-app"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.weather_app]
}
