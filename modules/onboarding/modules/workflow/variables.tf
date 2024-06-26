# modules/onboarding/modules/workflow/variables.tf

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "workflow_name" {
  description = "Name of the workflow"
  type        = string
}

variable "region" {
  description = "Google Cloud Region"
  type        = string
}

variable "khulnasoft_volscan_api_url" {
  description = "Khulnasoft Volume Scanning API URL"
  type        = string
}

variable "khulnasoft_volscan_api_token" {
  description = "Khulnasoft Volume Scanning API Token"
  type        = string
  sensitive   = true
}

variable "service_account_email" {
  description = "Email address of the service account associated with the workflow"
  type        = string
}