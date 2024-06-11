
# Defining local variables
locals {
  region                 = "us-central1"
  dedicated              = false
  type                   = "organization"
  org_name               = "my-org-name"
  khulnasoft_tenant_id         = "12345"
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
  project_id             = "my-project-id" # This project ID is used to create CSPM IAM resources
  labels                 = merge(local.khulnasoft_custom_labels, { "khulnasoft-agentless-scanner" = "true" })
  projects_list          = ["my-project-id-1", "my-project-id-2"]
}

################################

# Defining the root google provider
provider "google" {
  region         = local.region
  default_labels = local.labels
}

# Getting google organization ID
data "google_organization" "org" {
  domain = local.org_name
}

################################

# Creating CSPM IAM resources
module "khulnasoft_gcp_cspm_iam" {
  source = "../../modules/cspm_iam"
  providers = {
    google = google
  }
  project_id       = local.project_id
  khulnasoft_bucket_name = local.khulnasoft_bucket_name
  khulnasoft_tenant_id   = local.khulnasoft_tenant_id
  org_id           = data.google_organization.org.org_id
}

################################

# Iterating over all project and creating discovery and scanning resources each project
module "khulnasoft_gcp_onboarding" {
  source = "../../"
  providers = {
    google.onboarding = google
  }
  for_each               = toset(local.projects_list)
  type                   = local.type
  project_id             = each.value
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

# Iterating over all project and creating attachment resources
module "khulnasoft_gcp_projects_attachment" {
  source = "../../modules/project_attachment"
  providers = {
    google = google
  }
  for_each                                      = toset(local.projects_list)
  khulnasoft_api_key                                  = local.khulnasoft_api_key
  type                                          = local.type
  khulnasoft_api_secret                               = local.khulnasoft_api_secret
  khulnasoft_autoconnect_url                          = local.khulnasoft_autoconnect_url
  khulnasoft_bucket_name                              = local.khulnasoft_bucket_name
  khulnasoft_configuration_id                         = local.khulnasoft_configuration_id
  khulnasoft_cspm_group_id                            = local.khulnasoft_cspm_group_id
  org_name                                      = local.org_name
  project_id                                    = each.value
  dedicated_project                             = local.dedicated
  labels                                        = local.khulnasoft_custom_labels
  onboarding_create_role_id                     = module.khulnasoft_gcp_onboarding[each.value].create_role_id                     # Referencing outputs from the onboarding module
  onboarding_service_account_email              = module.khulnasoft_gcp_onboarding[each.value].service_account_email              # Referencing outputs from the onboarding module
  onboarding_cspm_service_account_key           = module.khulnasoft_gcp_cspm_iam.cspm_service_account_key                         # Referencing outputs from the cspm_iam module
  onboarding_workload_identity_pool_id          = module.khulnasoft_gcp_onboarding[each.value].workload_identity_pool_id          # Referencing outputs from the onboarding module
  onboarding_workload_identity_pool_provider_id = module.khulnasoft_gcp_onboarding[each.value].workload_identity_pool_provider_id # Referencing outputs from the onboarding module
  onboarding_project_number                     = module.khulnasoft_gcp_onboarding[each.value].project_number                     # Referencing outputs from the onboarding module
  depends_on                                    = [module.khulnasoft_gcp_onboarding]
}

output "onboarding_status" {
  value = {
    for project_id, attachment_instance in module.khulnasoft_gcp_projects_attachment :
    project_id => attachment_instance.onboarding_status
  }
}