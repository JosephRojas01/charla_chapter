resource "aws_s3_bucket" "bucket" {
  count  = length(var.s3_config) > 0 ? length(var.s3_config) : 0
  bucket = join("-", tolist([var.client, var.functionality, var.environment, "s3", var.s3_config[count.index].application, count.index + 1]))
  tags = merge({ Name = "${join("-", tolist([var.client, var.functionality, var.environment, "s3", var.s3_config[count.index].application, count.index + 1]))}" },
    { id_case = var.s3_config[count.index].ticket },
  { accessclass = var.s3_config[count.index].accessclass })
}


resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_bucket" {
  count  = length(var.s3_config) > 0 ? length(var.s3_config) : 0
  bucket = aws_s3_bucket.bucket[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_config[count.index].kms_key_id
      sse_algorithm     = "aws:kms"
    }

  }
}


resource "aws_s3_bucket_ownership_controls" "general_ownership" {
  count  = length(var.s3_config) > 0 ? length(var.s3_config) : 0
  bucket = aws_s3_bucket.bucket[count.index].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}



# # Recurso Public Acces Block
resource "aws_s3_bucket_public_access_block" "general_public_access" {
  count                   = length(var.s3_config) > 0 ? length(var.s3_config) : 0
  bucket                  = aws_s3_bucket.bucket[count.index].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# # Rescurso habilitando versionamiento.
resource "aws_s3_bucket_versioning" "s3_general_versioning" {
  count  = length(var.s3_config) > 0 ? length(var.s3_config) : 0
  bucket = aws_s3_bucket.bucket[count.index].id
  versioning_configuration {
    status = var.s3_config[count.index].versioning
  }
}

