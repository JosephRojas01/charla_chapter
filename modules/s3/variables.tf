variable "s3_config" {
  type = list(object({
    ticket      = string
    application = string
    kms_key_id = string
    accessclass = string
    versioning = string
  }))
}


variable "functionality" {
  type = string
}

variable "client" {
  type = string
}

variable "environment" {
  type = string
}