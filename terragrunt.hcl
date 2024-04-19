 locals {
   common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
   environment_vars = read_terragrunt_config(find_in_parent_folders("dev_variables.hcl"))
   region_vars = read_terragrunt_config(find_in_parent_folders("region_variables.hcl"))
 }

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
     profile = "${local.environment_vars.inputs.profile}"
     bucket = "chapter-terragrunt-${local.environment_vars.inputs.environment}-s3-assets-tfstate"
     key = "${path_relative_to_include()}/terraform.tfstate"
     region         = "${local.environment_vars.inputs.region}"
     encrypt        = true
     dynamodb_table = "chapter-terragrunt-${local.environment_vars.inputs.environment}-dynamodb-assets-tfstate"
   }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  provider "aws" {
    region  = "${local.region_vars.inputs.region}"
    profile = "${local.environment_vars.inputs.profile}"

    default_tags {
      tags = {
        environment = "${local.environment_vars.inputs.environment}"
        responsible = "CloudOps_Servicio"
        project_name = "infraestructure"
        stack_version = "Terraform_v1.4.6_on_windows_386"
        terragrunt_version = "terragrunt_version_v0.55.1"
      }
    }
  }
  EOF
}