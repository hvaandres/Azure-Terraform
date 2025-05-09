resource_groups = {
  "rg1" = {
    name     = "my-resource-group-1"
    location = "eastus"
    tags = {
      environment = "production"
    }
  },
  "rg2" = {
    name     = "my-resource-group-2"
    location = "westus2"
    tags = {
      environment = "development"
    }
  }
}

user_assigned_identity = {
  "identity1" = {
    user_assigned_identity_name = "my-user-identity-1"
    resource_group_name         = "my-resource-group-1"
    location                    = "eastus"
  },
  "identity2" = {
    user_assigned_identity_name = "my-user-identity-2"
    resource_group_name         = "my-resource-group-2"
    location                    = "westus2"
  }
}

storage_accounts = {
  "sa1" = {
    name                     = "mystorageaccount1"
    resource_group_name      = "my-resource-group-1"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    enable_versioning        = true
    tags = {
      environment = "production"
    }
  },
  "sa2" = {
    name                     = "mystorageaccount2"
    resource_group_name      = "my-resource-group-2"
    location                 = "westus2"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    enable_static_website    = true
    index_document           = "index.html"
    error_document           = "error.html"
  }
}

storage_account_containers = {
  "container1" = {
    name                 = "mycontainer1"
    storage_account_name = "mystorageaccount1"
    container_access_type = "private"
  },
  "container2" = {
    name                 = "mycontainer2"
    storage_account_name = "mystorageaccount2"
    container_access_type = "blob"
  }
}

federated_credentials = {
  "fc1" = {
    name                = "my-federated-credential-1"
    resource_group_name = "my-resource-group-1"
    issuer              = "https://token.actions.githubusercontent.com"
    subject             = "repo:myorg/myrepo:ref:refs/heads/main"
    audience            = ["api://AzureADTokenExchange"]
    parent_id           = "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/my-resource-group-1/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-user-identity-1"
  },
  "fc2" = {
    name                = "my-federated-credential-2"
    resource_group_name = "my-resource-group-2"
    issuer              = "https://token.actions.githubusercontent.com"
    subject             = "repo:myorg/myrepo:environment:production"
    parent_id           = "/subscriptions/12345678-1234-1234-1234-123456789012/resourcegroups/my-resource-group-2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-user-identity-2"
  }
}