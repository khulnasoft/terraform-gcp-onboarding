# modules/cspm_iam/variables.tf

variable "project_id" {
  description = "The Google Cloud Project ID where CSPM service account and organization IAM role will be created. This is relevant only for the 'organization - same' deployment setup."
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID must not be empty"
  }
}

variable "cspm_role_name" {
  description = "The name of the role used for CSPM"
  type        = string
  default     = "KhulnasoftAutoConnectCSPMRole"
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_-]{0,63}$", var.cspm_role_name))
    error_message = "Delete role name must start with a letter, contain only letters, numbers, hyphens, or underscores, and be between 1 and 64 characters long."
  }
}

variable "service_account_name" {
  description = "Name of the CSPM service account. If not provided, the default value is set to 'khulnasoft-cspm-scanner-<khulnasoft_tenant_id>' in the 'service_account_name' local"
  type        = string
  default     = null
}

variable "org_id" {
  description = "Google Cloud Organization ID"
  type        = string
  validation {
    condition     = length(var.org_id) > 0
    error_message = "Org ID must not be empty"
  }
}

variable "khulnasoft_tenant_id" {
  description = "Khulnasoft Tenant ID"
  type        = string
  validation {
    condition     = length(var.khulnasoft_tenant_id) > 0
    error_message = "Khulnasoft Tenant ID must not be empty"
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