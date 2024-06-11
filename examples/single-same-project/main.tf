
# Defining local variables
locals {
  region                 = "us-central1"
  dedicated              = false
  type                   = "single"
  org_name               = "" # Leave empty for same-project onboarding
  khulnasoft_tenant_id         = "12345"
  project_id             = "my-project-id"
  khulnasoft_aws_account_id    = "123456789101"
  khulnasoft_bucket_name       = "generic-bucket-name"
  khulnasoft_configuration_id  = "234e3cea-d84a-4b9e-bb36-92518e6a5772"
  khulnasoft_cspm_group_id     = 123456
  khulnasoft_custom_labels     = { label = "true" }
  khulnasoft_api_key           = "<REPLACE_ME>"
  khulnasoft_api_secret        = "<REPLACE_ME>"
  khulnasoft_autoconnect_url   = "https://example-khulnasoft-autoconnect-url.com"
  khulnasoft_volscan_api_token = "<REPLACE_ME>"
  khulnasoft_volscan_api_url   = "https://example-khulnasoft-volscan-api-url.com"
  labels                 = merge(local.khulnasoft_custom_labels, { "khulnasoft-agentless-scanner" = "true" })
}

################################

# Defining the root google provider
provider "google" {
  project        = local.project_id # Existing project to be onboarded
  region         = local.region
  default_labels = local.labels
}

################################

# Creating discovery and scanning resources on the project
module "khulnasoft_gcp_onboarding" {
  source = "../.."
  providers = {
    google.onboarding = google # Using the root project provider
  }
  type                   = local.type
  project_id             = local.project_id
  dedicated_project      = local.dedicated
  region                 = local.region
  org_name               = local.org_name
  khulnasoft_tenant_id         = local.khulnasoft_tenant_id
  khulnasoft_aws_account_id    = local.khulnasoft_aws_account_id
  khulnasoft_bucket_name       = local.khulnasoft_bucket_name
  khulnasoft_volscan_api_token = local.khulnasoft_volscan_api_token
  khulnasoft_volscan_api_url   = local.khulnasoft_volscan_api_url
}

################################

# Attaching the existing project to the onboarding resources
module "khulnasoft_gcp_project_attachment" {
  source = "../../modules/project_attachment"
  providers = {
    google = google # Using the root project provider
  }
  khulnasoft_api_key                                  = local.khulnasoft_api_key
  khulnasoft_api_secret                               = local.khulnasoft_api_secret
  khulnasoft_autoconnect_url                          = local.khulnasoft_autoconnect_url
  khulnasoft_bucket_name                              = local.khulnasoft_bucket_name
  khulnasoft_configuration_id                         = local.khulnasoft_configuration_id
  khulnasoft_cspm_group_id                            = local.khulnasoft_cspm_group_id
  type                                          = local.type
  org_name                                      = local.org_name
  project_id                                    = local.project_id
  dedicated_project                             = local.dedicated
  labels                                        = local.khulnasoft_custom_labels
  onboarding_create_role_id                     = module.khulnasoft_gcp_onboarding.create_role_id                     # Referencing outputs from the onboarding module
  onboarding_service_account_email              = module.khulnasoft_gcp_onboarding.service_account_email              # Referencing outputs from the onboarding module
  onboarding_workload_identity_pool_id          = module.khulnasoft_gcp_onboarding.workload_identity_pool_id          # Referencing outputs from the onboarding module
  onboarding_workload_identity_pool_provider_id = module.khulnasoft_gcp_onboarding.workload_identity_pool_provider_id # Referencing outputs from the onboarding module
  onboarding_project_number                     = module.khulnasoft_gcp_onboarding.project_number                     # Referencing outputs from the onboarding module
  depends_on                                    = [module.khulnasoft_gcp_onboarding]
}


output "onboarding_status" {
  value = module.khulnasoft_gcp_project_attachment.onboarding_status
}