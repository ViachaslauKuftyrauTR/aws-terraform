data "aws_elb_service_account" "main" {}
resource "aws_s3_bucket" "kuftyrau_bucket" {
  bucket = "s3-kuftyrau"
  acl    = "private"
  region = "${var.region}"
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::s3-kuftyrau/AWSLogs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}

