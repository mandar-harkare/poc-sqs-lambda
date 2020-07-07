locals {
  sqs_postfix = "${var.fifo_queue ? "${var.service_name}.fifo" : var.service_name}"
}


module "iam" {	
  source = "./iam"	

  short_region        = "${lookup(var.aws_region_map, var.aws_region)}"	
  stage               = "${var.stage}"	
  remote_stage        = "${var.remote_terraform_stage}"	
  aws_region          = "${var.aws_region}"	
  account_code        = "${var.account_code}"	
  queue_service       = "${local.sqs_postfix}"	
  service_name        = "${var.service_name}"
}

module "sqs" {
  source = "./sqs"

  short_region                      = "${lookup(var.aws_region_map, var.aws_region)}"
  stage                             = "${var.stage}"
  delay_seconds                     = "${var.delay_seconds}"
  max_message_size                  = "${var.max_message_size}"
  message_retention_seconds         = "${var.message_retention_seconds}"
  receive_wait_time_seconds         = "${var.receive_wait_time_seconds}"
  fifo_queue                        = "${var.fifo_queue}"
  content_based_deduplication       = "${var.content_based_deduplication}"
  queue_service                     = "${local.sqs_postfix}"
  visibility_timeout_seconds        = "${var.visibility_timeout_seconds}"
}

module "lmb" {
  source = "./lambda"
  short_region                        = "${lookup(var.aws_region_map, var.aws_region)}"
  stage                               = "${var.stage}"
  remote_stage                        = "${var.remote_terraform_stage}"
  aws_region                          = "${var.aws_region}"
  account_code                        = "${var.account_code}"
  queue_arn                           = "${module.sqs.queue_arn}"
  service_name                        = "${var.service_name}"
  lambda_timeout                      = "${var.lambda_timeout}"
  iam_role                            = "${module.iam.poc_iam_role}"
  lambda_configuration_cache_timeout  = "${var.lambda_configuration_cache_timeout}"
  lambda_memory_size                  = "${var.lambda_memory_size}"
  runtime                             = "${var.runtime}"
}
