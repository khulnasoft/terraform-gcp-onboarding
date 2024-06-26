# modules/project_attachment/data.tf

# Retrieve the YAML file containing the Khulnasoft CSPM role definition
data "http" "autoconnect_cspm_role_yaml" {
  count = var.type == "single" ? 1 : 0
  url   = "https://${var.khulnasoft_bucket_name}.s3.amazonaws.com/autoconnect_gcp_cspm_role.yaml"
}
