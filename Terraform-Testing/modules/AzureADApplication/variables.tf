variable "applications" {
  type = map(object({
    display_name            = string
    sign_in_audience        = optional(string, "AzureADMyOrg")
    redirect_uris           = optional(list(string))
    optional_claims_access_token = optional(list(string))
    tags                    = optional(list(string))
    use_existing            = optional(bool, false)
    feature_tags            = optional(object({
      enterprise = optional(bool)
      gallery    = optional(bool)
    }))
  }))
  description = "Map of Azure AD applications to create"
}