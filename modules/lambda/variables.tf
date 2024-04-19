variable "lambda_config" {
    type = list(object({
        s3_bucket = string
        s3_key = string
        description = string
        role = string
        handler = string
        runtime = string
        memory_size = string
        timeout = string
        application = string
        vpc_config = list(object({
            security_group_ids = list(string)
            subnet_ids = list(string)
        }))
    }))
}

variable "client" {

}

variable "project" {
    
}

variable "environment"  {

}