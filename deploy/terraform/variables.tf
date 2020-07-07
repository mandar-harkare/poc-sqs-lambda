// All necessary variables for the AWS resources
variable "service_name" {
  description = "The sub string service name, of the test Queue."
  default     = "test"
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue. If not set, it defaults to false making it standard."
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues."
  default     = false
}

variable "aws_region" {
  description = "Environment for deployment."
  default     = "us-east-2"
}

variable "aws_region_map" {
  description = "AWS region map by AWS region"
  type        = "map"

  default = {
    ap-south-1     = "aps1"
    eu-west-3      = "euw3"
    eu-west-2      = "euw2"
    eu-west-1      = "euw1"
    ap-northeast-2 = "apne2"
    ap-northeast-1 = "apne1"
    sa-east-1      = "sae1"
    ca-central-1   = "cac1"
    ap-southeast-1 = "apse1"
    ap-southeast-2 = "apse2"
    eu-central-1   = "euc1"
    us-east-1      = "use1"
    us-east-2      = "use2"
    us-west-1      = "usw1"
    us-west-2      = "usw2"
  }
}

variable "stage" {
  description = "Environment for deployment."
  default     = "d"
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed."
  default     = 0
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it."
  default     = 2048
}

variable "message_retention_seconds" {
  description = "Time to live, message lifespan in an SQS queue."
  default     = 86400
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)."
  default     = 10
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue."
  default     = 120
}

variable "lambda_timeout" {
  description = "The timeout for the lambda execution."
  default     = 120
}

variable "account_code" {
  description = "Your AWS Account Code."
  default     = 0000
}

variable "remote_terraform_stage" {
  description = "Stage for the remote backend."
  default     = "d"
}

variable "remote_short_region" {
  description = "The remote AWS region, use a naming convention for the CPT team eg. use2 (eu-west-1)."
  default     = "euw1"
}

variable "remote_aws_region" {
  description = "Remote region for saving the state"
  default     = "eu-west-1"
}

variable "lambda_configuration_cache_timeout" {
  description = "time remaining (in seconds) when cache times out - set to 2 minutes"
  default     = 120
}

variable "lambda_memory_size" {
  description = "defaults to 256"
  default     = 256
}
  
variable "runtime" {
  description = "nodejs runtime"
  default     = "nodejs12.x"
}
