data "aws_iam_policy_document" "poc_policy_read_doc" {
  statement {
    sid    = "VisualEditor0"
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:ListQueues",
      "sqs:GetQueueUrl",
      "sqs:GetQueueAttributes"
    ]

    resources = [
      "arn:aws:sqs:${var.aws_region}:${var.account_code}:poc-sqs-demo",
    ]
  }
}

data "aws_iam_policy_document" "poc_policy_send_doc" {
  statement {
    sid    = "VisualEditor0"
    effect = "Allow"

    actions = [
      "sqs:SendMessage",
    ]

    resources = [
      "arn:aws:sqs:${var.aws_region}:${var.account_code}:poc-sqs-demo",
    ]
  }
}

// The policies for the SQS Queue
resource "aws_iam_policy" "poc_sqs_read_pol" {
  name   = "poc-pol-sqs-read"
  policy = "${data.aws_iam_policy_document.ers_sqs_policy_read_doc.json}"
}

resource "aws_iam_policy" "poc_sqs_send_pol" {
  name   = "poc-pol-sqs-send"
  policy = "${data.aws_iam_policy_document.ers_sqs_policy_send_doc.json}"
}

// Role
resource "aws_iam_role" "iam_for_lambda" {
  name = "poc-role-for-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

// attach policy to role

resource "aws_iam_policy_attachment" "poc-read-attach" {
  name       = "poc-read-attachment"
  roles      = ["${aws_iam_role.iam_for_lambda.name}"]
  policy_arn = "${aws_iam_policy.poc_sqs_read_pol.arn}"
}

resource "aws_iam_policy_attachment" "poc-send-attach" {
  name       = "poc-send-attachment"
  roles      = ["${aws_iam_role.iam_for_lambda.name}"]
  policy_arn = "${aws_iam_policy.poc_sqs_send_pol.arn}"
}