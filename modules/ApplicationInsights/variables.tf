variable "application_insights" {
  description = "Map of Application Insights configurations"
  type = map(object({
    # Required fields
    name                = string
    location            = string
    resource_group_name = string
    application_type    = string

    # Optional fields
    tags = optional(map(string))

    # Workspace configuration
    workspace_id = optional(string)

    # Connection string configuration
    connection_string = optional(object({
      instrumentation_key             = optional(string)
      application_id                  = optional(string)
      connection_string               = optional(string)
    }))

    # Retention configuration
    retention_in_days = optional(number, 90)

    # Daily data cap
    daily_data_cap_in_gb = optional(number)
    daily_data_cap_notifications_disabled = optional(bool)

    # Internet ingestion and streaming
    disable_ip_masking = optional(bool)
    force_customer_storage_for_profiler = optional(bool)

    # Sampling configuration
    sampling_percentage = optional(number)
  }))
  default = {}
}