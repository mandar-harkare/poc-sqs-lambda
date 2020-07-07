output "poc_sqs_read_pol" {
  value = "${aws_iam_policy.ers_sqs_read_pol.name}"
}

output "poc_sqs_send_pol" {
  value = "${aws_iam_policy.poc_sqs_send_pol.name}"
}

output "poc_iam_role" {
  value = "${aws_iam_role.iam_for_lambda.name}"
}