module "labels" {
  source = "cloudposse/label/null"

  name  = var.name
  stage = var.stage
}

resource "aws_sns_topic" "this" {
  name            = "my-sns-topic"
  delivery_policy = jsonencode({
    "http" : {
      "defaultHealthyRetryPolicy" : {
        "minDelayTarget" : 20,
        "maxDelayTarget" : 20,
        "numRetries" : 3,
        "numMaxDelayRetries" : 0,
        "numNoDelayRetries" : 0,
        "numMinDelayRetries" : 0,
        "backoffFunction" : "linear"
      },
      "disableSubscriptionOverrides" : false,
      "defaultThrottlePolicy" : {
        "maxReceivesPerSecond" : 1
      }
    }
  })
}

resource "aws_sns_topic_subscription" "topic_email_subscription" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = "vladyslav.yakubovskyi.ri.2022@lpnu.ua"
}

locals {
  get_all_authors_log_group_name = "/aws/lambda/dev-lambda-get-course"
  get_all_courses_log_group_name = "/aws/lambda/dev-lambda-get-all-courses"
  get_course_log_group_name      = "/aws/lambda/dev-lambda-get-course"
  save_course_log_group_name     = "/aws/lambda/dev-lambda-save-course"
  update_course_log_group_name   = "/aws/lambda/dev-lambda-update-course"
  delete_course_log_group_name   = "/aws/lambda/dev-lambda-delete-course"
}

resource "aws_cloudwatch_log_metric_filter" "get_all_authors" {
  name          = "get-all-authors-metric-filter"
  pattern       = "ERROR"
  log_group_name = local.get_all_authors_log_group_name

  metric_transformation {
    name      = "EventCount"
    namespace = "get-all-authors-metric-namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "get_all_authors-alarm" {
  alarm_name                = "get-all-authors-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = aws_cloudwatch_log_metric_filter.get_all_authors.metric_transformation[0].name
  namespace                 = "get-all-authors-metric-namespace"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = 1
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.this.arn]
}


resource "aws_cloudwatch_log_metric_filter" "get_all_courses" {
  name          = "get-all-courses-metric-filter"
  pattern       = "ERROR"
  log_group_name = local.get_all_courses_log_group_name

   metric_transformation {
    name      = "EventCount"
    namespace = "get-all-courses-metric-namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "get_all_courses-alarm" {
  alarm_name                = "get-all-courses-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = aws_cloudwatch_log_metric_filter.get_all_courses.metric_transformation[0].name
  namespace                 = "get-all-courses-metric-namespace"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = 1
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.this.arn]
}

resource "aws_cloudwatch_log_metric_filter" "get_course" {
  name          = "get-course-metric-filter"
  pattern       = "ERROR"
  log_group_name = local.get_course_log_group_name

   metric_transformation {
    name      = "EventCount"
    namespace = "get-course-metric-namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "get_course-alarm" {
  alarm_name                = "get-course-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = aws_cloudwatch_log_metric_filter.get_course.metric_transformation[0].name
  namespace                 = "get-course-metric-namespace"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = 1
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.this.arn]
}

resource "aws_cloudwatch_log_metric_filter" "save_course" {
  name          = "save-course-metric-filter"
  pattern       = "ERROR"
  log_group_name = local.save_course_log_group_name

   metric_transformation {
    name      = "EventCount"
    namespace = "save-course-metric-namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "save_course-alarm" {
  alarm_name                = "save-course-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = aws_cloudwatch_log_metric_filter.save_course.metric_transformation[0].name
  namespace                 = "save-course-metric-namespace"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = 1
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.this.arn]
}

resource "aws_cloudwatch_log_metric_filter" "update_course" {
  name          = "update-course-metric-filter"
  pattern       = "ERROR"
  log_group_name = local.update_course_log_group_name

   metric_transformation {
    name      = "EventCount"
    namespace = "update-course-metric-namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "update_course-alarm" {
  alarm_name                = "update-course-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = aws_cloudwatch_log_metric_filter.update_course.metric_transformation[0].name
  namespace                 = "update-course-metric-namespace"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = 1
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.this.arn]
}

resource "aws_cloudwatch_log_metric_filter" "delete_course" {
  name          = "delete-course-metric-filter"
  pattern       = "ERROR"
  log_group_name = local.delete_course_log_group_name

   metric_transformation {
    name      = "EventCount"
    namespace = "delete-course-metric-namespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "delete_course-alarm" {
  alarm_name                = "delete-course-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = aws_cloudwatch_log_metric_filter.delete_course.metric_transformation[0].name
  namespace                 = "delete-course-metric-namespace"
  period                    = 60
  statistic                 = "Sum"
  threshold                 = 1
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.this.arn]
}

resource "aws_sns_topic" "billing" {
  name            = "${var.stage}-billing-alarm-notification"
  delivery_policy = jsonencode({
    "http" : {
      "defaultHealthyRetryPolicy" : {
        "minDelayTarget" : 20,
        "maxDelayTarget" : 20,
        "numRetries" : 3,
        "numMaxDelayRetries" : 0,
        "numNoDelayRetries" : 0,
        "numMinDelayRetries" : 0,
        "backoffFunction" : "linear"
      },
      "disableSubscriptionOverrides" : false,
      "defaultThrottlePolicy" : {
        "maxReceivesPerSecond" : 1
      }
    }
  })
}

resource "aws_sns_topic_subscription" "topic_billing_email_subscription" {
  topic_arn = aws_sns_topic.billing.arn
  protocol  = "email"
  endpoint  = "vladyslav.yakubovskyi.ri.2022@lpnu.ua"
}

module "billing_alert" {
  source = "billtrust/billing-alarm/aws"

  aws_env                   = var.stage
  monthly_billing_threshold = 1
  currency                  = "USD"
}
