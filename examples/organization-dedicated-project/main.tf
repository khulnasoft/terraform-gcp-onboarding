
# Defining local variables
locals {
  region                 = "us-central1"
  dedicated              = true
  type                   = "organization"
  org_name               = "my-org-name"
  khulnasoft_tenant_id         = "12345"
  billing_account_id     = "012A3B-4567CD-8EFGH9"
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
  dedicated_project_id   = "khulnasoft-agentless-${local.khulnasoft_tenant_id}-${local.org_hash}"
  project_id             = "my-project-id" # This project ID is used to run the Cloud Asset query to fetch all project IDs and create CSPM IAM resources
  projects_list          = module.khulnasoft_gcp_org_projects.filtered_projects
  labels                 = merge(local.khulnasoft_custom_labels, { "khulnasoft-agentless-scanner" = "true" })
  org_hash               = substr(sha1(local.org_name), 0, 6)
}

################################

# Defining the root google provider
provider "google" {
  region         = local.region
  default_labels = local.labels
}

################################

# Defining the org_projects google provider to fetch all projects ids
provider "google" {
  alias                 = "org_projects"
  region                = local.region
  default_labels        = local.labels
  user_project_override = true
  billing_project       = local.project_id
  project               = local.project_id
}

# Fetching all active projects ids
module "khulnasoft_gcp_org_projects" {
  source = "../../modules/org_projects"
  providers = {
    google = google.org_projects
  }
  org_name = local.org_name
}

################################

# Creating a dedicated project
module "khulnasoft_gcp_dedicated_project" {
  source             = "../../modules/dedicated_project"
  org_name           = local.org_name
  project_id         = local.dedicated_project_id
  type               = local.type
  billing_account_id = local.billing_account_id
  labels             = local.labels
}

################################

# Defining the dedicated google provider
provider "google" {
  alias          = "dedicated"
  project        = module.khulnasoft_gcp_dedicated_project.project_id
  region         = local.region
  default_labels = local.labels
}

# Creating discovery and scanning resources on the dedicated project
module "khulnasoft_gcp_onboarding" {
  source = "../../"
  providers = {
    google.onboarding = google.dedicated
  }
  type                   = local.type
  project_id             = module.khulnasoft_gcp_dedicated_project.project_id
  dedicated_project      = local.dedicated
  region                 = local.region
  org_name               = local.org_name
  khulnasoft_tenant_id         = local.khulnasoft_tenant_id
  khulnasoft_aws_account_id    = local.khulnasoft_aws_account_id
  khulnasoft_bucket_name       = local.khulnasoft_bucket_name
  khulnasoft_volscan_api_token = local.khulnasoft_volscan_api_token
  khulnasoft_volscan_api_url   = local.khulnasoft_volscan_api_url
  depends_on             = [module.khulnasoft_gcp_dedicated_project]
}

################################

# Iterating over all project and attaching them to the dedicated project
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
  onboarding_create_role_id                     = module.khulnasoft_gcp_onboarding.create_role_id                     # Referencing outputs from the onboarding module
  onboarding_cspm_service_account_key           = module.khulnasoft_gcp_onboarding.cspm_service_account_key           # Referencing outputs from the onboarding module
  onboarding_service_account_email              = module.khulnasoft_gcp_onboarding.service_account_email              # Referencing outputs from the onboarding module
  onboarding_workload_identity_pool_id          = module.khulnasoft_gcp_onboarding.workload_identity_pool_id          # Referencing outputs from the onboarding module
  onboarding_workload_identity_pool_provider_id = module.khulnasoft_gcp_onboarding.workload_identity_pool_provider_id # Referencing outputs from the onboarding module
  onboarding_project_number                     = module.khulnasoft_gcp_onboarding.project_number                     # Referencing outputs from the onboarding module
  depends_on                                    = [module.khulnasoft_gcp_onboarding]
}

output "onboarding_status" {
  value = {
    for project_id, attachment_instance in module.khulnasoft_gcp_projects_attachment :
    project_id => attachment_instance.onboarding_status
  }
}
