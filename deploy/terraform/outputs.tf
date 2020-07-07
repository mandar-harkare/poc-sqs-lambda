output "aws_region" {
  value = "${var.aws_region}"
}

output "short_region" {
  value = "${lookup(var.aws_region_map, var.aws_region)}"
}

output "stage" {
  value = "${var.stage}"
}

output "service_name" {
  value = "${var.service_name}"
}

output "queue_name" {
  value = "${module.sqs.queue_name}"
}

output "queue_url" {
  value = "${module.sqs.queue_url}"
}

output "queue_arn" {
  value = "${module.sqs.queue_arn}"
}

output "policy_send_name" {	
  value = "${module.iam.poc_sqs_send_pol}"	
}	

output "policy_read_name" {	
  value = "${module.iam.poc_sqs_read_pol}"	
}

output "poc_iam_role" {	
  value = "${module.iam.poc_iam_role}"	
}