terraform {
    source = "${get_parent_terragrunt_dir()}/modules/kms"
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
    kms_config = [
        {
            description = "Kms for s3 encryption"
            enable_key_rotation = true
            statements = [
                {
                    sid = "kms_users"
                    actions = [
                        "kms:Create*",
                        "kms:Describe*",
                        "kms:Enable*",
                        "kms:List*",
                        "kms:Put*",
                        "kms:Update*",
                        "kms:Revoke*",
                        "kms:Disable*",
                        "kms:Get*",
                        "kms:Decrypt",
                        "kms:Encrypt",
                        "kms:GenerateDataKey",
                        "kms:Delete*",
                        "kms:ScheduleKeyDeletion",
                        "kms:CancelKeyDeletion"
                    ]
                    resources = ["*"]
                    effect = "Allow"
                    type = "AWS"
                    identifiers = ["arn:aws:iam::${local.common_vars.inputs.account}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_pragma-ps-cloudops-services_b5293a49a161ed83"]
                    condition = []
                }
            ]
            ticket = "2811"
            application = "dynamo"
        }
    ]
}