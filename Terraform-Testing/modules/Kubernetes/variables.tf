variable "kubernetes_clusters" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    dns_prefix          = string
    kubernetes_version  = optional(string)
    default_node_pool   = object({
      name       = string
      node_count = number
      vm_size    = string
    })
    network_profile = optional(object({
      network_plugin    = string
      load_balancer_sku = string
    }))
    tags = optional(map(string))
  }))
  description = "Map of Azure Kubernetes Service clusters to create"
}
