## modules/onboarding/modules/iam/data.tf

# Retrieve the YAML file containing the Khulnasoft create role definition
data "http" "autoconnect_create_role_yaml" {
  url = "https://${var.khulnasoft_bucket_name}.s3.amazonaws.com/autoconnect_gcp_agentless_role.yaml"
}

# Retrieve the YAML file containing the Khulnasoft delete role definition
data "http" "autoconnect_delete_role_yaml" {
  url = "https://${var.khulnasoft_bucket_name}.s3.amazonaws.com/autoconnect_gcp_agentless_delete_role.yaml"
}

# Retrieve the YAML file containing the Khulnasoft CSPM role definition
data "http" "autoconnect_cspm_role_yaml" {
  url = "https://${var.khulnasoft_bucket_name}.s3.amazonaws.com/autoconnect_gcp_cspm_role.yaml"
}