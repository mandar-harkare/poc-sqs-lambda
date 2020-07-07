output "queue_name" {
  value = "${aws_sqs_queue.ers_sqs_queue.name}"
}

output "queue_url" {
  description = "The URL for the created Amazon SQS queue"
  value       = "${aws_sqs_queue.ers_sqs_queue.id}"
}

output "queue_arn" {
  description = "The ARN for the created Amazon SQS queue"
  value       = "${aws_sqs_queue.ers_sqs_queue.arn}"
}