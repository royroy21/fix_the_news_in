resource "aws_s3_bucket" "media" {
  bucket = "${var.environment}-fixthenews"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "DELETE"]
    allowed_origins = [
        "https://${var.django_name}.${var.domain_name}",
    ]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "media" {
  bucket = aws_s3_bucket.media.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "${var.environment}_s3_bucket_policy",
    "Statement": [
        {
          "Sid":"Allow get requests originating from ${var.webapp_name}.${var.domain_name}",
          "Effect":"Allow",
          "Principal":"*",
          "Action":["s3:GetObject"],
          "Resource":"${aws_s3_bucket.media.arn}/*",
          "Condition":{
            "StringLike":{"aws:Referer":["https://${var.webapp_name}.${var.domain_name}/*"]}
          }
        },
        {
          "Sid":"Allow get, put and delete requests originating from ${var.django_name}.${var.domain_name}",
          "Effect":"Allow",
          "Principal":"*",
          "Action":["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
          "Resource":"${aws_s3_bucket.media.arn}/*",
          "Condition":{
            "StringLike":{"aws:Referer":["https://${var.django_name}.${var.domain_name}/*"]}
          }
        }
    ]
}
POLICY
}
