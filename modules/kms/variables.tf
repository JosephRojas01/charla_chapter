variable "kms_config" {
  type = list(object({
    description         = string
    enable_key_rotation = bool
    statements = list(object({
      sid         = string
      actions     = list(string)
      resources   = list(string)
      effect      = string
      type        = string
      identifiers = list(string)
      condition = list(object({
        test     = string
        variable = string
        values   = list(string)
      }))
    }))
    ticket      = string
    application = string
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
