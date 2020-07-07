// See variables.tf for values
resource "aws_sqs_queue" "poc_sqs_queue" {
  name                              = "poc-sqs-demo"
  delay_seconds                     = "${var.delay_seconds}"
  max_message_size                  = "${var.max_message_size}"
  message_retention_seconds         = "${var.message_retention_seconds}"
  receive_wait_time_seconds         = "${var.receive_wait_time_seconds}"
  fifo_queue                        = "${var.fifo_queue}"
  content_based_deduplication       = "${var.content_based_deduplication}"
  visibility_timeout_seconds        = "${var.visibility_timeout_seconds}"

}
