locals {
  bucket_name = "bart-parka-blog-assets"
}

module "s3" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = local.bucket_name
  tags   = var.tags

  versioning = {
    enabled = false
  }

  attach_policy                         = true
  policy                                = data.aws_iam_policy_document.bucket_policy.json
  attach_deny_insecure_transport_policy = true

  # Allow deletion of non-empty bucket
  force_destroy = true

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
  }
}

resource "aws_s3_object" "object" {
  for_each = fileset(path.module, "images/**")
  bucket   = local.bucket_name
  key      = each.value
  source   = each.value

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(each.value)

  depends_on = [module.s3]
}