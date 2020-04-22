resource "aws_sns_topic" "example" {
  name = "fanout-example"
}

resource "aws_sqs_queue" "example_a" {
  name = "fanout-example-application-a"
}

resource "aws_sqs_queue" "example_b" {
  name = "fanout-example-application-b"
}

resource "aws_sqs_queue_policy" "orders_queue_policy" {
  queue_url  = aws_sqs_queue.example_a.id
  depends_on = [aws_sqs_queue.example_a]
  policy     = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.example_a.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.example.arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sqs_queue_policy" "analytics_queue_policy" {
  queue_url  = aws_sqs_queue.example_b.id
  depends_on = [aws_sqs_queue.example_b]
  policy     = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.example_b.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.example.arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sns_topic_subscription" "inventory_sqs_target" {
  topic_arn  = aws_sns_topic.example.arn
  protocol   = "sqs"
  endpoint   = aws_sqs_queue.example_a.arn
  depends_on = [aws_sqs_queue.example_a]
}

resource "aws_sns_topic_subscription" "analytics_sqs_target" {
  topic_arn  = aws_sns_topic.example.arn
  protocol   = "sqs"
  endpoint   = aws_sqs_queue.example_b.arn
  depends_on = [aws_sqs_queue.example_b]
}

output "sqs_url_a" {
  value = aws_sqs_queue.example_a.id
}

output "sqs_url_b" {
  value = aws_sqs_queue.example_b.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.example.arn
}
