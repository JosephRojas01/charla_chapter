output "s3_info" {
   value = [for s3 in aws_s3_bucket.bucket : {"s3_arn" : s3.arn,"s3_id" : s3.id, "s3_domain_name" : s3.bucket_regional_domain_name, "s3_name" : s3.tags_all.Name}]
}
