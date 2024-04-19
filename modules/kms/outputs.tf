output "kms_info" {
  value = [for key in aws_kms_alias.alias : {"key_id" : key.target_key_id, "key_alias" : key.name, "key_arn" : key.arn}]
}
