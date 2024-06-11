# `workflow` module

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.20.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_workflows_workflow.workflows_workflow](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/workflows_workflow) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_khulnasoft_api_token"></a> [khulnasoft\_api\_token](#input\_khulnasoft\_api\_token) | Khulnasoft API Token | `string` | n/a | yes |
| <a name="input_khulnasoft_api_url"></a> [khulnasoft\_api\_url](#input\_khulnasoft\_api\_url) | Khulnasoft API URL | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Google Cloud Region | `string` | n/a | yes |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | Email address of the service account associated with the workflow | `string` | n/a | yes |
| <a name="input_workflow_name"></a> [workflow\_name](#input\_workflow\_name) | Name of the workflow | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workflow_name"></a> [workflow\_name](#output\_workflow\_name) | Name of the created workflow |
<!-- END_TF_DOCS -->
