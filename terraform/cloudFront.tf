resource "aws_s3_bucket" "empatica-fe-static" {
   bucket = "empatica-fe-static"
   region  = "eu-west-1"
   policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::empatica-fe-static/*"]
    }]
  }
  POLICY
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_cloudfront_distribution" "frontend_cloudfront_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.empatica-fe-static.website_endpoint}"
    origin_id   = "empatica-fe-static"


    custom_origin_config {
      http_port              = "80"
      https_port              = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]

    }
  }
  
  enabled             = true
  default_root_object = "index.html"
  
  default_cache_behavior {
    viewer_protocol_policy = "allow-all"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "empatica-fe-static"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 31536000
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  
  custom_error_response {
    error_caching_min_ttl = 3000
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}