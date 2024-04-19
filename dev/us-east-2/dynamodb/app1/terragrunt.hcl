terraform {
    source = "${get_parent_terragrunt_dir()}/modules/dynamodb"
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("dev_variables.hcl"))
}


include "root" {
    path = find_in_parent_folders()
}

inputs = {
    client = local.common_vars.inputs.client
    functionality = "assets"
    environment = local.environment_vars.inputs.environment
    dynamo_config = [
        {
            billing_mode = "PAY_PER_REQUEST"
            read_capacity = 0
            write_capacity = 0
            hash_key = "ID"
            range_key = ""
            application = "test"
            ticket = ""
            point_in_time_recovery = "true"
            deletion_protection_enabled = true
            attributes = [
                {
                    name = "ID"
                    type = "S"
                }
            ]
            server_side_encryption = []
            replicas = []
        }
    ]
}