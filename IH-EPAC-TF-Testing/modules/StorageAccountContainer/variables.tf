variable "base_name_container" {
    type = string
    description = "The base name of the container"
  
}

variable "storage_account_id" {
    type = string
    description = "We need to located the storage account id"
}

variable "container_access_type" {
    type = string
    description = "We need to define if the access is public or private"
    default = "private"
}