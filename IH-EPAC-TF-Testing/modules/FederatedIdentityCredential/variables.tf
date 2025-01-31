variable "federated_identity" {
  description = "The name of the federated identity credential."
  type        = map(object({
    rg_name                    = string
    audience_name              = string
    issuer_url                 = string
    user_assigned_identity_id = string
    subject                    = string
  }))
}