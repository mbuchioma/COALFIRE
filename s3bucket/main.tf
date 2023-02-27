resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project}-02s3"

  tags = {
    Name        =  "${var.project}-s3"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_object" "object" {
  for_each = toset(["Images", "Logs"])
  bucket = aws_s3_bucket.bucket.id
  key = each.key
  server_side_encryption = "AES256"
}


resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "Images"

    status = "Enabled"

    transition {
      days          = var.transition_day
      storage_class = var.storage_class
    }
  }

  rule {
    id = "Logs"

    expiration {
      days = var.transition_day
    }

    status = "Enabled"
  }
}
