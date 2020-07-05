data "aws_caller_identity" "current" {}

# Bucket with access log configuration
resource "aws_s3_bucket" "bucket2" {
  bucket = "${data.aws_caller_identity.current.account_id}-bucket2"
  acl = "private"
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }

}

resource "aws_s3_bucket" "bucket3" {
  bucket = "${data.aws_caller_identity.current.account_id}-bucket3"
  tags = {
    # Implicit dependency 
    dependency = aws_s3_bucket.bucket2.arn
  }
}

resource "aws_s3_bucket" "bucket4" {
  bucket = "${data.aws_caller_identity.current.account_id}-bucket4"
  # Explicit dependency
  depends_on = [
    aws_s3_bucket.bucket3
  ]
}

# create a logging bucket
# log delivery should be set to write

resource "aws_s3_bucket" "log_bucket" {
  bucket        = "${data.aws_caller_identity.current.account_id}-log-bucket"
  acl           = "log-delivery-write"
  force_destroy = true
}
