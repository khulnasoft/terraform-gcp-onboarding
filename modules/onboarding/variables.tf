# modules/onboarding/variables.tf

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "type" {
  description = "The type of onboarding. Valid values are 'single' or 'organization' onboarding types"
  type        = string
}

variable "enabled" {
  description = "Whether to create the onboarding resources"
  type        = bool
  default     = true
}

variable "project_number" {
  description = "Google Cloud Project Number"
  type        = number
}

variable "khulnasoft_tenant_id" {
  description = "Khulnasoft Tenant ID"
  type        = string
}

variable "dedicated_project" {
  description = "Indicates whether dedicated project is enabled"
  type        = bool
}

variable "region" {
  description = "Google Cloud Region"
  type        = string
}

variable "topic_name" {
  description = "Name of the Pub/Sub topic"
  type        = string
}

variable "sink_name" {
  description = "Name of the sink"
  type        = string
}

variable "workflow_name" {
  description = "Name of the workflow"
  type        = string
}

variable "trigger_name" {
  description = "Name of the trigger"
  type        = string
}

variable "network_name" {
  description = "Name of the network"
  type        = string
}

variable "firewall_name" {
  description = "Name of the firewall"
  type        = string
}

variable "service_account_name" {
  description = "Name of the service account"
  type        = string
}

variable "identity_pool_name" {
  description = "The name of the identity pool"
  type        = string
}

variable "identity_pool_provider_name" {
  description = "The name of the identity pool provider"
  type        = string
}

variable "org_id" {
  description = "Google Cloud Organization ID"
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

variable "khulnasoft_aws_account_id" {
  description = "Khulnasoft AWS Account ID"
  type        = string
}

variable "create_network" {
  description = "Toggle to create network resources"
  type        = bool
}

variable "khulnasoft_bucket_name" {
  description = "Khulnasoft Bucket Name"
  type        = string
}

variable "create_role_name" {
  description = "The name of the role to be created for Khulnasoft"
  type        = string
}

variable "delete_role_name" {
  description = "The name of the role used for deleting Khulnasoft resources"
  type        = string
}

variable "cspm_role_name" {
  description = "The name of the role used for CSPM"
  type        = string
}
