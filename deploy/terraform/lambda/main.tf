resource "aws_lambda_function" "poc_lmb_function" {
  filename         = "../../poc_function.zip"
  function_name    = "poc-lmb-function"
  role             = "arn:aws:iam::${var.account_code}:role/${var.iam_role}"
  handler          = "src/index.update"
  runtime          = "${var.runtime}"
  source_code_hash = "${base64sha256(file("../../poc_function.zip"))}"
  timeout          = "${var.lambda_timeout}"
  memory_size      = "${var.lambda_memory_size}"

  environment {
    variables = {
      SERVICE_NAME                        = "${var.service_name}"
      STAGE                               = "${var.stage}"
      REGION                              = "${var.aws_region}"
    }
  }

  tracing_config {
    mode = "Active"
  }

}

# Event source from SQS
resource "aws_lambda_event_source_mapping" "poc_source_mapping" {
  event_source_arn = "${var.queue_arn}"
  function_name    = "${aws_lambda_function.poc_lmb_function.arn}"
  batch_size       = 1

  # defaults to true
  enabled = true
}
