![Khulnasoft logo](https://avatars3.githubusercontent.com/u/43526139?s=200&v=4)

# Terraform-gcp-onboarding

[![Release](https://img.shields.io/github/v/release/khulnasoft/terraform-gcp-onboarding)](https://github.com/khulnasoft/terraform-gcp-onboarding/releases)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This Terraform module provides an easy way
to configure Khulnasoft Security’s CSPM and agentless solutions on Google Cloud Platform (GCP).

It creates the necessary resources, such as service accounts, roles, and permissions,
to enable seamless integration with Khulnasoft’s platform.

---

## Table of Contents

- [Pre-requisites](#Pre-requisites)
- [Usage](#usage)
- [Examples](#examples)
- [Providing Project ID List](#providing-project-id-list)
- [Excluding Projects Using Regex](#excluding-projects-using-regex)
- [Using Dedicated Project](#using-an-existing-dedicated-project)
- [Using Existing Network](#using-existing-network-and-firewall)

## Pre-requisites

Before using this module, ensure that you have the following:

- Terraform version `1.6.4` or later.
- `gcloud` CLI installed and configured.
- `Python` 3+ installed.
- Khulnasoft Security account API credentials.

## Usage
1. Leverage the Khulnasoft platform to generate the local variables required by the module.
2. Important: Replace `khulnasoft_api_key` and `khulnasoft_api_secret` with your generated API credentials.
3. Run `terraform init` to initialize the module.
4. Run `terraform apply` to create the resources.

## Examples

### Onboarding a Single Project using a dedicated project

Here's an example of how to onboard a single project while using a dedicated project to host the infrastructure:

```hcl

# Defining local variables
locals {
  region                 = "us-central1"                                 # Google Cloud region to use
  dedicated              = true                                          # Whether to create a dedicated project for Khulnasoft resources
  type                   = "single"                                      # Type of deployment (single project or organization)
  org_name               = "my-org-name"                                 # Google Cloud Organization name
  khulnasoft_tenant_id         = "12345"                                       # Khulnasoft tenant ID
  project_id             = "project_id"                                  # Google Cloud project ID (existing project to be onboarded)
  khulnasoft_aws_account_id    = "123456789101"                                # Khulnasoft AWS account ID
  khulnasoft_bucket_name       = "generic-bucket-name"                         # Khulnasoft bucket name
  khulnasoft_configuration_id  = "234e3cea-d84a-4b9e-bb36-92518e6a5772"        # Khulnasoft configuration ID
  khulnasoft_cspm_group_id     = 123456                                        # Khulnasoft CSPM group ID
  khulnasoft_custom_labels     = { label = "true" }                            # Additional custom labels to apply to Khulnasoft resources
  khulnasoft_api_key           = "REPLACE_ME"                                  # Replace with generated khulnasoft API key
  khulnasoft_api_secret        = "REPLACE_ME"                                  # Replace with generated khulnasoft API secret
  khulnasoft_autoconnect_url   = "https://example-khulnasoft-autoconnect-url.com"    # Khulnasoft Autoconnect API URL
  khulnasoft_volscan_api_token = "REPLACE_ME"                                  # Replace with Khulnasoft Volume Scanning API token
  khulnasoft_volscan_api_url   = "https://example-khulnasoft-volscan-api-url.com"    # Khulnasoft Volume Scanning API URL
  dedicated_project_id   = "khulnasoft-agentless-${local.tenant_id}-${local.org_hash}"
  labels                 = merge(local.khulnasoft_custom_labels, { "khulnasoft-agentless-scanner" = "true" }) # Combined labels for Khulnasoft resources
  org_hash               = substr(sha1(local.org_name), 0, 6)                                     # Hashed organization name (first 6 characters)
}

################################

# Defining the root google provider
provider "google" {
  project        = local.project_id # Existing project to be onboarded
  region         = local.region
  default_labels = local.labels
}

# Creating a dedicated project for Khulnasoft resources
module "khulnasoft_gcp_dedicated_project" {
  source          = "khulnasoft/onboarding/gcp//modules/dedicated_project"
  org_name        = local.org_name
  type            = local.type
  project_id      = local.dedicated_project_id
  root_project_id = local.project_id
  labels          = local.labels
}

################################

# Defining the dedicated google provider
provider "google" {
  alias          = "dedicated"
  project        = module.khulnasoft_gcp_dedicated_project.project_id
  region         = local.region
  default_labels = local.labels
}

# Creating onboarding resources on the dedicated project
module "khulnasoft_gcp_onboarding" {
  source = "khulnasoft/onboarding/gcp"
  providers = {
    google.onboarding = google.dedicated # Using the dedicated project provider
  }
  type                   = local.type
  project_id             = module.khulnasoft_gcp_dedicated_project.project_id # Dedicated project for Khulnasoft resources
  region                 = local.region
  dedicated_project      = local.dedicated
  org_name               = local.org_name
  khulnasoft_tenant_id         = local.khulnasoft_tenant_id
  khulnasoft_aws_account_id    = local.khulnasoft_aws_account_id
  khulnasoft_bucket_name       = local.khulnasoft_bucket_name
  khulnasoft_volscan_api_token = local.khulnasoft_volscan_api_token
  khulnasoft_volscan_api_url   = local.khulnasoft_volscan_api_url
  depends_on             = [module.khulnasoft_gcp_dedicated_project]
}

################################

## Onboarding the existing project and attaching it to the dedicated project
module "khulnasoft_gcp_project_attachment" {
  source = "khulnasoft/onboarding/gcp//modules/project_attachment"
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
  project_id                                    = local.project_id # Existing project to be onboarded
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
```

---

### Onboarding an Organization using a dedicated project 

Here's an example of how to onboard an organization while using a dedicated project to host the infrastructure:

```hcl

# Defining local variables
locals {
  region                 = "us-central1"                               # Google Cloud region to use
  dedicated              = true                                        # Whether to create a dedicated project for Khulnasoft resources
  type                   = "organization"                              # Type of deployment (single project or organization)
  org_name               = "my-org-name"                               # Google Cloud Organization name
  khulnasoft_tenant_id         = "12345"                                     # Khulnasoft tenant ID
  billing_account_id     = "012A3B-4567CD-8EFGH9"                      # Google Cloud billing account ID
  khulnasoft_aws_account_id    = "123456789101"                              # Khulnasoft AWS account ID
  khulnasoft_bucket_name       = "generic-bucket-name"                       # Khulnasoft bucket name
  khulnasoft_configuration_id  = "234e3cea-d84a-4b9e-bb36-92518e6a5772"      # Khulnasoft configuration ID
  khulnasoft_cspm_group_id     = 123456                                      # Khulnasoft CSPM group ID
  khulnasoft_custom_labels     = { label = "true" }                          # Additional custom labels to apply to Khulnasoft resources
  khulnasoft_api_key           = "<REPLACE_ME>"                              # Replace with generated khulnasoft API key
  khulnasoft_api_secret        = "<REPLACE_ME>"                              # Replace with generated khulnasoft API secret
  khulnasoft_autoconnect_url   = "https://example-khulnasoft-autoconnect-url.com"  # Khulnasoft Autoconnect API URL
  khulnasoft_volscan_api_token = "<REPLACE_ME>"                              # Replace with Khulnasoft Volume Scanning API token
  khulnasoft_volscan_api_url   = "https://example-khulnasoft-volscan-api-url.com"  # Khulnasoft Volume Scanning API URL
  dedicated_project_id   = "khulnasoft-agentless-${local.khulnasoft_tenant_id}-${local.org_hash}"
  project_id             = "my-project-id"                             # Google Cloud project ID used to run the Cloud Asset query to fetch all project IDs and create CSPM IAM resources (Cloud Asset API must be enabled)
  projects_list          = module.khulnasoft_gcp_org_projects.filtered_projects 
  labels                 = merge(local.khulnasoft_custom_labels, { "khulnasoft-agentless-scanner" = "true" }) # Combined labels for Khulnasoft resources
  org_hash               = substr(sha1(local.org_name), 0, 6)                                     # Hashed organization name (first 6 characters)
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
  source   = "../../modules/org_projects"
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
  project        = module.khulnasoft_gcp_dedicated_project.project_id # Dedicated project for Khulnasoft resources
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

## Iterating over all project and attaching them to the dedicated project
module "khulnasoft_gcp_projects_attachment" {
  source = "../../modules/project_attachment"
  providers = {
    google = google # Using the root project provider
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
  project_id                                    = each.value # Referencing each project from given project id list 
  dedicated_project                             = local.dedicated
  labels                                        = local.khulnasoft_custom_labels
  onboarding_create_role_id                     = module.khulnasoft_gcp_onboarding.create_role_id                       # Referencing outputs from the onboarding module
  onboarding_cspm_service_account_key           = module.khulnasoft_gcp_onboarding.cspm_service_account_key             # Referencing outputs from the onboarding module
  onboarding_service_account_email              = module.khulnasoft_gcp_onboarding.service_account_email               # Referencing outputs from the onboarding module
  onboarding_workload_identity_pool_id          = module.khulnasoft_gcp_onboarding.workload_identity_pool_id           # Referencing outputs from the onboarding module
  onboarding_workload_identity_pool_provider_id = module.khulnasoft_gcp_onboarding.workload_identity_pool_provider_id  # Referencing outputs from the onboarding module
  onboarding_project_number                     = module.khulnasoft_gcp_onboarding.project_number                      # Referencing outputs from the onboarding module
  depends_on                                    = [module.khulnasoft_gcp_onboarding]
}

output "onboarding_status" {
  value = {
    for project_id, attachment_instance in module.khulnasoft_gcp_projects_attachment :
    project_id => attachment_instance.onboarding_status
  }
}
```
For more examples and use cases, please refer to the examples folder in the repository.

## Providing Project ID List

By default we fetch all active projects and use that project list, but you can also provide your own list of project IDs by populating the `projects_list` local. To accommodate this, ensure to remove the `module.khulnasoft_gcp_org_projects` and then replace the local `projects_list` with your list.

```hcl
locals {
projects_list = [
  "my-project-id-1",
  "my-project-id-2",
  // Add more project IDs as needed
]
}
```

## Excluding Projects Using Regex

You can exclude specific projects from getting onboarded by using regular expressions.

To exclude projects by id, add the variable `projects_ids_exclude="regex1, regex2, regex3"` to the module `khulnasoft_gcp_org_projects`.

To exclude projects by name, add the variable `projects_names_exclude="regex1, regex2, regex3"` to the module `khulnasoft_gcp_org_projects`.

Here are some examples of traditional exclusions following the instructions above:

1. Exclude Projects Starting with `test-`:
    - Regex: `^test-.*$`
    - Description: This regex pattern matches GCP project names that start with `test-`.

2. Exclude Projects Ending with `-test`:
    - Regex: `^.*-test$`
    - Description: This regex pattern matches GCP project names that end with `-test`.

3. Exclude Projects which include test anywhere:
    - Regex: `.*test.*`
    - Description: This regex pattern matches GCP project names containing the word `test` anywhere in the name.

## Using an Existing Dedicated Project

If you have an existing dedicated project that you want to use to host Khulnasoft Security resources, you can import it into the Terraform configuration.

To do so, use the following Terraform import command:

`terraform import module.khulnasoft_gcp_dedicated_project.google_project.project <dedicated_project_id>`


Replace `<dedicated_project_id>` with the ID of your existing dedicated project.

It's important to note that the dedicated project ID should follow the naming convention `"khulnasoft-agentless-${local.tenant_id}-${local.org_hash}"`, where local.org_hash is calculated as:

`org_hash = substr(sha1(<org_name>), 0, 6)`

You can also check for the naming convention using the bash command:

```bash
#!/bin/bash

# Replace with your Khulnasoft tenant ID
TENANT_ID="<your_tenant_id>"

# Replace with your organization name
ORG_NAME="<your_org_name>"

# Calculate the org_hash
ORG_HASH=$(echo -n "${ORG_NAME}" | shasum -a 1 | awk '{ print $1 }' | cut -c1-6)

# Print the dedicated project ID naming convention
echo "khulnasoft-agentless-${TENANT_ID}-${ORG_HASH}"                                    
```

For example, if your Khulnasoft tenant ID is `12345` and the first six characters of the SHA1 hash of your organization name are `12a456`, the dedicated project ID should be `khulnasoft-agentless-12345-12a456`.


## Using Existing Network and Firewall


If you prefer to use an existing network and firewall instead of creating new ones,
you can do so by setting `create_network = false` in the onboarding module input variables.
In this case, you will need to create,
prior to onboarding, network and firewall resources with the following naming convention:

Dedicated project:
* Firewall: `<project_id>-rules-khulnasoft-aas`
* Network: `<project_id>-network`

Same project:
* Firewall: `<project_id>-rules-<khulnasoft_tenant_id>khulnasoft-aas`
* Network: `<project_id>-network-<khulnasoft_tenant_id>`

When using a dedicated project, the `<project_id>` should follow the format `"khulnasoft-agentless-${local.tenant_id}-${local.org_hash}"` as mentioned above.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.4 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.30.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.4.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.30.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_onboarding"></a> [onboarding](#module\_onboarding) | ./modules/onboarding | n/a |

## Resources

| Name | Type |
|------|------|
| [google_organization.organization](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/organization) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_khulnasoft_aws_account_id"></a> [khulnasoft\_aws\_account\_id](#input\_khulnasoft\_aws\_account\_id) | Khulnasoft AWS Account ID | `string` | n/a | yes |
| <a name="input_khulnasoft_bucket_name"></a> [khulnasoft\_bucket\_name](#input\_khulnasoft\_bucket\_name) | Khulnasoft Bucket Name | `string` | n/a | yes |
| <a name="input_khulnasoft_tenant_id"></a> [khulnasoft\_tenant\_id](#input\_khulnasoft\_tenant\_id) | Khulnasoft Tenant ID | `string` | n/a | yes |
| <a name="input_khulnasoft_volscan_api_token"></a> [khulnasoft\_volscan\_api\_token](#input\_khulnasoft\_volscan\_api\_token) | Khulnasoft Volume Scanning API Token | `string` | n/a | yes |
| <a name="input_khulnasoft_volscan_api_url"></a> [khulnasoft\_volscan\_api\_url](#input\_khulnasoft\_volscan\_api\_url) | Khulnasoft volume scanning API URL | `string` | n/a | yes |
| <a name="input_create_network"></a> [create\_network](#input\_create\_network) | Toggle to create network resources | `bool` | `true` | no |
| <a name="input_create_role_name"></a> [create\_role\_name](#input\_create\_role\_name) | The name of the role to be created for Khulnasoft | `string` | `"KhulnasoftAutoConnectAgentlessRole"` | no |
| <a name="input_cspm_role_name"></a> [cspm\_role\_name](#input\_cspm\_role\_name) | The name of the role used for CSPM | `string` | `"KhulnasoftAutoConnectCSPMRole"` | no |
| <a name="input_dedicated_project"></a> [dedicated\_project](#input\_dedicated\_project) | Indicates whether dedicated project is enabled | `bool` | `true` | no |
| <a name="input_delete_role_name"></a> [delete\_role\_name](#input\_delete\_role\_name) | The name of the role used for deleting Khulnasoft resources | `string` | `"AutoConnectDeleteRole"` | no |
| <a name="input_identity_pool_name"></a> [identity\_pool\_name](#input\_identity\_pool\_name) | Name of the identity pool. If not provided, the default value is set to 'khulnasoft-agentless-pool-<khulnasoft\_tenant\_id>' in the 'identity\_pool\_name' local | `string` | `null` | no |
| <a name="input_identity_pool_provider_name"></a> [identity\_pool\_provider\_name](#input\_identity\_pool\_provider\_name) | Name of the identity pool provider. If not provided, the default value is set to 'agentless-provider-<khulnasoft\_tenant\_id>' in the 'identity\_pool\_provider\_name' local | `string` | `null` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Google Cloud Organization name | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud Onboarding Project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Google Cloud Main Deployment Region | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the service account. If not provided, the default value is set to 'khulnasoft-agentless-sa-<khulnasoft\_tenant\_id>' in the 'service\_account\_name' local | `string` | `null` | no |
| <a name="input_show_outputs"></a> [show\_outputs](#input\_show\_outputs) | Whether to show outputs after deployment | `bool` | `false` | no |
| <a name="input_sink_name"></a> [sink\_name](#input\_sink\_name) | Name of the sink. If not provided, the default value is set to '<project\_id>-sink' in the 'sink\_name' local | `string` | `null` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | Name of the topic. If not provided, the default value is set to '<project\_id>-topic' in the 'topic\_name' local | `string` | `null` | no |
| <a name="input_trigger_name"></a> [trigger\_name](#input\_trigger\_name) | Name of the trigger. If not provided, the default value is set to '<project\_id>-trigger' in the 'trigger\_name' local | `string` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | The type of onboarding. Valid values are 'single' or 'organization' onboarding types | `string` | n/a | yes |
| <a name="input_workflow_name"></a> [workflow\_name](#input\_workflow\_name) | Name of the workflow. If not provided, the default value is set to '<project\_id>-workflow' in the 'workflow\_name' local | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_create_role_id"></a> [create\_role\_id](#output\_create\_role\_id) | Create role ID |
| <a name="output_create_role_name"></a> [create\_role\_name](#output\_create\_role\_name) | Create role name |
| <a name="output_create_role_permissions"></a> [create\_role\_permissions](#output\_create\_role\_permissions) | Permissions of the created role |
| <a name="output_cspm_role_id"></a> [cspm\_role\_id](#output\_cspm\_role\_id) | CSPM role ID |
| <a name="output_cspm_role_name"></a> [cspm\_role\_name](#output\_cspm\_role\_name) | CSPM role name |
| <a name="output_cspm_role_permissions"></a> [cspm\_role\_permissions](#output\_cspm\_role\_permissions) | Permissions of the CSPM role |
| <a name="output_cspm_service_account_email"></a> [cspm\_service\_account\_email](#output\_cspm\_service\_account\_email) | CSPM Service account email |
| <a name="output_cspm_service_account_id"></a> [cspm\_service\_account\_id](#output\_cspm\_service\_account\_id) | CSPM Service account ID |
| <a name="output_cspm_service_account_key"></a> [cspm\_service\_account\_key](#output\_cspm\_service\_account\_key) | CSPM Service account key |
| <a name="output_cspm_service_account_name"></a> [cspm\_service\_account\_name](#output\_cspm\_service\_account\_name) | CSPM Service account name |
| <a name="output_delete_role_name"></a> [delete\_role\_name](#output\_delete\_role\_name) | Delete role name |
| <a name="output_delete_role_permissions"></a> [delete\_role\_permissions](#output\_delete\_role\_permissions) | Permissions of the deleted role |
| <a name="output_eventarc_trigger_destination_workflow"></a> [eventarc\_trigger\_destination\_workflow](#output\_eventarc\_trigger\_destination\_workflow) | Destination workflow for the eventarc trigger |
| <a name="output_eventarc_trigger_name"></a> [eventarc\_trigger\_name](#output\_eventarc\_trigger\_name) | Eventarc trigger name |
| <a name="output_firewall_name"></a> [firewall\_name](#output\_firewall\_name) | Firewall name |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | Network name |
| <a name="output_org_id"></a> [org\_id](#output\_org\_id) | Google Cloud Organization ID |
| <a name="output_org_name"></a> [org\_name](#output\_org\_name) | Google Cloud Organization name |
| <a name="output_project_api_services"></a> [project\_api\_services](#output\_project\_api\_services) | API services enabled in the project |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Google Cloud Project ID |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | Google Cloud Project number |
| <a name="output_pubsub_topic_name"></a> [pubsub\_topic\_name](#output\_pubsub\_topic\_name) | Pubsub topic name |
| <a name="output_region"></a> [region](#output\_region) | Google Cloud Region |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | Service account email |
| <a name="output_service_account_id"></a> [service\_account\_id](#output\_service\_account\_id) | Service account ID |
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | Service account name |
| <a name="output_sink_name"></a> [sink\_name](#output\_sink\_name) | Sink name |
| <a name="output_workflow_name"></a> [workflow\_name](#output\_workflow\_name) | Workflow name |
| <a name="output_workload_identity_pool_id"></a> [workload\_identity\_pool\_id](#output\_workload\_identity\_pool\_id) | Workload identity pool ID |
| <a name="output_workload_identity_pool_provider_id"></a> [workload\_identity\_pool\_provider\_id](#output\_workload\_identity\_pool\_provider\_id) | Workload identity pool provider ID |
| <a name="output_workload_identity_pool_provider_id_aws_account_id"></a> [workload\_identity\_pool\_provider\_id\_aws\_account\_id](#output\_workload\_identity\_pool\_provider\_id\_aws\_account\_id) | Workload identity pool provider AWS account ID |
<!-- END_TF_DOCS -->
