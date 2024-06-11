# terraform-gcp-onboarding
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
| <a name="input_create_network"></a> [create\_network](#input\_create\_network) | Toggle to create network resources | `bool` | `true` | no |
| <a name="input_create_role_name"></a> [create\_role\_name](#input\_create\_role\_name) | The name of the role to be created for Khulnasoft | `string` | `"KhulnasoftAutoConnectAgentlessRole"` | no |
| <a name="input_cspm_role_name"></a> [cspm\_role\_name](#input\_cspm\_role\_name) | The name of the role used for CSPM | `string` | `"KhulnasoftAutoConnectCSPMRole"` | no |
| <a name="input_dedicated_project"></a> [dedicated\_project](#input\_dedicated\_project) | Indicates whether dedicated project is enabled | `bool` | `true` | no |
| <a name="input_delete_role_name"></a> [delete\_role\_name](#input\_delete\_role\_name) | The name of the role used for deleting Khulnasoft resources | `string` | `"AutoConnectDeleteRole"` | no |
| <a name="input_identity_pool_name"></a> [identity\_pool\_name](#input\_identity\_pool\_name) | Name of the identity pool. If not provided, the default value is set to 'khulnasoft-agentless-pool-<khulnasoft\_tenant\_id>' in the 'identity\_pool\_name' local | `string` | `null` | no |
| <a name="input_identity_pool_provider_name"></a> [identity\_pool\_provider\_name](#input\_identity\_pool\_provider\_name) | Name of the identity pool provider. If not provided, the default value is set to 'agentless-provider-<khulnasoft\_tenant\_id>' in the 'identity\_pool\_provider\_name' local | `string` | `null` | no |
| <a name="input_khulnasoft_aws_account_id"></a> [khulnasoft\_aws\_account\_id](#input\_khulnasoft\_aws\_account\_id) | Khulnasoft AWS Account ID | `string` | n/a | yes |
| <a name="input_khulnasoft_bucket_name"></a> [khulnasoft\_bucket\_name](#input\_khulnasoft\_bucket\_name) | Khulnasoft Bucket Name | `string` | n/a | yes |
| <a name="input_khulnasoft_tenant_id"></a> [khulnasoft\_tenant\_id](#input\_khulnasoft\_tenant\_id) | Khulnasoft Tenant ID | `string` | n/a | yes |
| <a name="input_khulnasoft_volscan_api_token"></a> [khulnasoft\_volscan\_api\_token](#input\_khulnasoft\_volscan\_api\_token) | Khulnasoft Volume Scanning API Token | `string` | n/a | yes |
| <a name="input_khulnasoft_volscan_api_url"></a> [khulnasoft\_volscan\_api\_url](#input\_khulnasoft\_volscan\_api\_url) | Khulnasoft volume scanning API URL | `string` | n/a | yes |
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