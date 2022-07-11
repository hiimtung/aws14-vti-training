locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))
}
resource "aws_s3_bucket" "aws14-s3" {
  bucket = var.bucket
  acl = var.acl
  policy = file("s3_policy.json")
}
resource "aws_s3_bucket_object" "aws14-s3-object" {
  for_each = fileset(path.module, "objects/**/*")
  bucket = aws_s3_bucket.aws14-s3.id
  key = replace(each.value,"objects","")
  source = each.value
  etag = filemd5("${each.value}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$",each.value),null)
}