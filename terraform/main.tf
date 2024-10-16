terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubernetes-alpha = {
      source = "hashicorp/kubernetes-alpha"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "9da3e56f-c072-474c-97af-e80f7c0e83f9"
}

# Create Resource Group
resource "azurerm_resource_group" "group" {
  name     = "rg-weather-app"
  location = "East US"
  tags = {
    "Terraform" = "true"
  }
}

# Create Kubernetes Cluster
resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "weatherapp-cluster"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  dns_prefix          = "weatherapp"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "development"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.cluster.kube_config_raw
  sensitive = true
}
