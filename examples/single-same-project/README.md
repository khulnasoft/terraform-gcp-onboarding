# Onboarding a Project with Infrastructure on the Project Example

---

## Overview

This example demonstrates how to onboard an existing Google Cloud Platform (GCP) project to Khulnasoft Security by provisioning all the necessary resources directly into the existing project, without creating a dedicated project.

## Prerequisites

Before running this example, ensure that you have the following:

1. Terraform installed (version 1.6.4 or later).
2. `gcloud` CLI installed and configured.
3. Khulnasoft Security account and API credentials.

## Usage

1. Obtain the Terraform configuration file generated by the Khulnasoft platform.
2. Important: Replace `<khulnasoft_api_key>` and `<khulnasoft_api_secret>` with your generated API credentials.
3. Run `terraform init` to initialize the Terraform working directory.
4. Run `terraform apply` to create the resources.

## What's Happening

1. The `khulnasoft_gcp_onboarding` module is called to provision the necessary resources (service accounts, roles, networking, etc.) directly in the existing GCP project.
2. The `khulnasoft_gcp_project_attachment` module is called to create the required IAM resources in the existing project and trigger the Khulnasoft API to onboard the project.

## Outputs

- `onboarding_status`: The output from the `khulnasoft_gcp_project_attachment` module, displaying the result of the onboarding process.

## Cleanup

To remove the resources created by this example, run `terraform destroy`.