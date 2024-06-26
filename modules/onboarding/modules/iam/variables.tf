# modules/onboarding/modules/iam/variables.tf

variable "service_account_name" {
  description = "The name of the service account to be created"
  type        = string
}

variable "dedicated_project" {
  description = "Indicates whether dedicated project is enabled"
  type        = bool
}

variable "type" {
  description = "The type of onboarding. Valid values are 'single' or 'organization' onboarding types"
  type        = string
}

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "project_number" {
  description = "Google Cloud Project Number"
  type        = string
}

variable "org_id" {
  description = "Google Cloud Organization ID"
  type        = string
}

variable "create_role_name" {
  description = "The name of the custom IAM role for the 'create' role"
  type        = string
}

variable "delete_role_name" {
  description = "The name of the custom IAM role for the 'delete' role"
  type        = string
}

variable "cspm_role_name" {
  description = "The name of the custom IAM role for the cspm role"
  type        = string
}

variable "identity_pool_name" {
  description = "The name of the Workload Identity Pool to be created"
  type        = string
}

variable "identity_pool_provider_name" {
  description = "The name of the Workload Identity Pool Provider to be created"
  type        = string
}

variable "khulnasoft_aws_account_id" {
  description = "The AWS account ID associated with the Khulnasoft resources"
  type        = string
}

variable "khulnasoft_bucket_name" {
  description = "The name of the Khulnasoft S3 bucket"
  type        = string
}

variable "khulnasoft_tenant_id" {
  description = "Khulnasoft Tenant ID"
  type        = string
}