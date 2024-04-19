resource "aws_lambda_function" "function" {
    for_each = { for item in var.lambda_config :
    item.application => {
      "index" : index(var.lambda_config, item)
      "s3_bucket" : item.s3_bucket
      "s3_key" : item.s3_key
      "description" : item.description
      "role" : item.role
      "handler" : item.handler
      "runtime" : item.runtime
      "memory_size" : item.memory_size
      "timeout" : item.timeout
      "vpc_config" : item.vpc_config
    }
  }
  s3_bucket     = each.value["s3_bucket"]
  s3_key        = each.value["s3_key"]
  function_name = join("-", tolist([var.client, var.project,each.key,"lambda",var.environment]))
  description   = each.value["description"]
  role          = each.value["role"]
  handler       = each.value["handler"]
  runtime       = each.value["runtime"]
  memory_size   = each.value["memory_size"]
  timeout       = each.value["timeout"]


  dynamic "vpc_config" {
    for_each = each.value["vpc_config"]
    content {
        security_group_ids = vpc_config.value["security_group_ids"]
        subnet_ids = vpc_config.value["subnet_ids"]
    }
  }

  tags = { Name = join("-", tolist([var.client, var.project,each.key,"lambda",var.environment])) }
}
