# locals.tf

locals {
  # Organization-related locals
  org_id = var.dedicated_project ? data.google_organization.organization[0].org_id : null # Using null because same-project does not use org_id

  # Project-related locals
  project_number = data.google_project.project.number
  project_id     = data.google_project.project.project_id

  # Resource naming locals
  identity_pool_name          = var.identity_pool_name != null ? var.identity_pool_name : "khulnasoft-agentless-pool-${var.khulnasoft_tenant_id}"
  identity_pool_provider_name = var.identity_pool_provider_name != null ? var.identity_pool_provider_name : "agentless-provider-${var.khulnasoft_tenant_id}"
  service_account_name        = var.service_account_name != null ? var.service_account_name : "khulnasoft-agentless-sa-${var.khulnasoft_tenant_id}"
  firewall_name               = var.dedicated_project ? "${local.project_id}--rules-khulnasoft-aas" : "${local.project_id}-rules-${var.khulnasoft_tenant_id}-khulnasoft-aas"
  network_name                = var.dedicated_project ? "${local.project_id}-network" : "${local.project_id}-network-${var.khulnasoft_tenant_id}"
  topic_name                  = var.topic_name != null ? var.topic_name : (var.dedicated_project ? "${local.project_id}-topic" : "${local.project_id}-topic-${var.khulnasoft_tenant_id}")
  sink_name                   = var.sink_name != null ? var.sink_name : (var.dedicated_project ? "${local.project_id}-sink" : "${local.project_id}-sink-${var.khulnasoft_tenant_id}")
  workflow_name               = var.workflow_name != null ? var.workflow_name : (var.dedicated_project ? "${local.project_id}-workflow" : "${local.project_id}-workflow-${var.khulnasoft_tenant_id}")
  trigger_name                = var.trigger_name != null ? var.trigger_name : (var.dedicated_project ? "${local.project_id}-trigger" : "${local.project_id}-trigger-${var.khulnasoft_tenant_id}")
}
