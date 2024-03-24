#create S3 bucket
resource "aws_s3_bucket" "mystaticbucket" {
  bucket = var.bucketname

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mystaticbucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mystaticbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mystaticbucket.id
  acl    = "public-read"
}
resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.mystaticbucket.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}
resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.mystaticbucket.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}
resource "aws_s3_bucket_object" "engineering-technicians" {
  bucket = aws_s3_bucket.mystaticbucket.id
  key    = "engineering-technicians.jpg"
  source = "engineering-technicians.jpg"
  acl = "public-read"

}
resource "aws_s3_bucket_website_configuration" "Website" {
  bucket = aws_s3_bucket.mystaticbucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  depends_on = [aws_s3_bucket_acl.example]
}