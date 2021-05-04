provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "group_example" {
  name     = "${var.name}-group"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name                = var.name
  location            = azurerm_resource_group.group_example.location
  resource_group_name = azurerm_resource_group.group_example.name
  dns_prefix          = "${var.name}dns"

  default_node_pool {
    name       = "node${var.name}"
    node_count = var.count_nodes
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.k8s_cluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s_cluster.kube_config_raw
  sensitive = true
}

output "dns_cluser" {
  value = azurerm_kubernetes_cluster.k8s_cluster.fqdn
}

output "cluster_name" {
  value = var.name
}