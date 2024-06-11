# modules/project_attachment/variables.tf

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID must not be empty"
  }
}

variable "type" {
  description = "The type of onboarding. Valid values are 'single' or 'organization' onboarding types"
  type        = string
  validation {
    condition     = var.type == "single" || var.type == "organization"
    error_message = "Only 'single' or 'organization' onboarding types are supported"
  }
}

variable "cspm_role_name" {
  description = "The name of the role used for CSPM"
  type        = string
  default     = "KhulnasoftAutoConnectRole"
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_-]{0,63}$", var.cspm_role_name))
    error_message = "Delete role name must start with a letter, contain only letters, numbers, hyphens, or underscores, and be between 1 and 64 characters long."
  }
}

variable "khulnasoft_bucket_name" {
  description = "Khulnasoft Bucket Name"
  type        = string
  validation {
    condition     = length(var.khulnasoft_bucket_name) > 0
    error_message = "Khulnasoft Bucket Name must not be empty"
  }
}

variable "khulnasoft_api_key" {
  description = "Khulnasoft API key"
  type        = string
  validation {
    condition     = length(var.khulnasoft_api_key) > 0
    error_message = "Khulnasoft API key must not be empty"
  }
}

variable "khulnasoft_api_secret" {
  description = "Khulnasoft API secret"
  type        = string
  validation {
    condition     = length(var.khulnasoft_api_secret) > 0
    error_message = "Khulnasoft API secret must not be empty"
  }
}

variable "khulnasoft_autoconnect_url" {
  description = "Khulnasoft Autoconnect API URL"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.khulnasoft_autoconnect_url))
    error_message = "Khulnasoft Autoconnect API URL must start with or 'https://'"
  }
}

variable "khulnasoft_cspm_group_id" {
  description = "Khulnasoft CSPM Group ID"
  type        = number
  validation {
    condition     = var.khulnasoft_cspm_group_id != null
    error_message = "Khulnasoft CSPM Group ID must not be empty"
  }
}

variable "khulnasoft_configuration_id" {
  description = "Khulnasoft Configuration ID"
  type        = string
  validation {
    condition     = length(var.khulnasoft_configuration_id) > 0
    error_message = "Khulnasoft Configuration ID must not be empty"
  }
}

variable "dedicated_project" {
  description = "Indicates whether dedicated project is enabled"
  type        = bool
  default     = true
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.dedicated_project))
    error_message = "Dedicated project toggle must be either true or false."
  }
}

variable "org_name" {
  description = "Google Cloud Organization name"
  type        = string
}

variable "labels" {
  description = "Additional resource labels to will be send to the Autoconnect API"
  type        = map(string)
  default     = {}
}

variable "onboarding_create_role_id" {
  description = "ID of the create role that has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
  default     = ""
}

variable "onboarding_project_number" {
  description = "Google Cloud Project Number has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
}

variable "onboarding_workload_identity_pool_provider_id" {
  description = "ID of the workload identity pool provider that has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
  validation {
    condition     = length(var.onboarding_workload_identity_pool_provider_id) > 0
    error_message = "Onboarding workload identity pool provider id must not be empty"
  }
}

variable "onboarding_workload_identity_pool_id" {
  description = "ID of the workload identity pool that has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
  validation {
    condition     = length(var.onboarding_workload_identity_pool_id) > 0
    error_message = "Onboarding workload identity pool id must not be empty"
  }
}

variable "onboarding_service_account_email" {
  description = "Email of the service account that has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
  validation {
    condition     = length(var.onboarding_service_account_email) > 0
    error_message = "Onboarding service account email must not be empty"
  }
}

variable "onboarding_cspm_service_account_key" {
  description = "The Key of the CSPM service account that has been created in the root module. This should be referenced from the root onboarding module only for organization dedicated onboarding."
  type        = string
  default     = ""
  sensitive   = true
}