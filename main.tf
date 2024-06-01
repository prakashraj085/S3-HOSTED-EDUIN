resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

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

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}



# Upload index.html
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "index.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "about" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "about.html"
  source = "about.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "courses" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "courses.html"
  source = "courses.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "contact" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "contact.html"
  source = "contact.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "links" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "links.html"
  source = "links.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "css" {
  for_each = fileset(path.module, "/css/*.css")

  bucket = aws_s3_bucket.mybucket.id
  key    = "${each.value}"
  source = "${each.value}"
  acl    = "public-read"
  content_type = "text/css"
}


resource "aws_s3_object" "js_file" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "main.js"  
  source = "main.js"  
  acl    = "public-read"
  content_type = "application/javascript"
}

# Upload error.html
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "error.html"
  acl    = "public-read"
  content_type = "text/html"
}


resource "aws_s3_bucket_object" "images" {
  for_each = fileset(path.module, "images/*")

  bucket = aws_s3_bucket.mybucket.id
  key    = "${each.value}"
  source = "${each.value}"
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "svg_images" {
  for_each = fileset(path.module, "svg/*.svg")

  bucket = aws_s3_bucket.mybucket.id
  key    = "${each.value}"
  source = "${each.value}"
  acl    = "public-read"
  content_type = "svg+xml" 
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.example ]

}

