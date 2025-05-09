resource_groups = {
  rg1 = { location = "westus", base_name = "wus-aharo", tags = { 
    Environment = "Epac-Test"
    Project     = "Terraform"
    Contact     = "Andres Haro"
    Department  = "CyberSecurity"
    Support     = "support@support.com"
  } }

  rg2 = { location = "westus", base_name = "wus-aharo-02", tags = { 
    Environment = "Epac-Test"
    Project     = "Terraform"
    Contact     = "Andres Haro"
    Department  = "CyberSecurity"
    Support     = "support@support.com"
  } }

  rg3 = { location = "westus", base_name = "wus-aharo-03", tags = { 
    Environment = "Epac-Test"
    Project     = "Terraform"
    Contact     = "Andres Haro"
    Department  = "CyberSecurity"
    Support     = "support@support.com"
  } }
}