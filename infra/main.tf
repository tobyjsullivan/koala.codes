terraform {
  backend "s3" {
    bucket = "terraform-states.tobyjsullivan.com"
    key = "states/koala.codes/terraform.tfstate"
    region = "us-east-1"
  }
}

variable "cloudflare_email" {}
variable "cloudflare_api_key" {}
variable "domain" {
  default = "koala.codes"
}
variable "cloudflare_domain" {
  default = "koala.codes"
}

output "s3_bucket" {
  value = var.domain
}

provider "aws" {
  region = "ca-central-1"
}

provider "cloudflare" {
  email = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

data "cloudflare_zones" "website" {
  filter {
    name = var.domain
  }
}

resource "aws_s3_bucket" "website" {
  bucket = var.domain
  force_destroy = false
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": ["arn:aws:s3:::${var.domain}/*"]
        }
    ]
}
EOF
  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket" "www" {
  bucket = "www.${var.domain}"
  force_destroy = true

  website {
    redirect_all_requests_to = "https://${var.domain}"
  }
}

resource "cloudflare_record" "root" {
  zone_id = lookup(data.cloudflare_zones.website.zones[0], "id")
  name = var.domain
  value = aws_s3_bucket.website.website_endpoint
  type = "CNAME"
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = lookup(data.cloudflare_zones.website.zones[0], "id")
  name = "www.${var.domain}"
  value = cloudflare_record.root.hostname
  type = "CNAME"
  proxied = true
}

resource "cloudflare_record" "email1" {
  zone_id = lookup(data.cloudflare_zones.website.zones[0], "id")
  name = var.domain
  value = "aspmx.l.google.com"
  type = "MX"
  priority = 1
}

resource "cloudflare_record" "email2" {
  zone_id = lookup(data.cloudflare_zones.website.zones[0], "id")
  name = var.domain
  value = "alt1.aspmx.l.google.com"
  type = "MX"
  priority = 5
}

resource "cloudflare_record" "email3" {
  zone_id = lookup(data.cloudflare_zones.website.zones[0], "id")
  name = var.domain
  value = "alt2.aspmx.l.google.com"
  type = "MX"
  priority = 5
}

resource "cloudflare_record" "email4" {
  zone_id = lookup(data.cloudflare_zones.website.zones[0], "id")
  name = var.domain
  value = "alt3.aspmx.l.google.com"
  type = "MX"
  priority = 10
}

resource "cloudflare_record" "email5" {
  zone_id = lookup(data.cloudflare_zones.website.zones[0], "id")
  name = var.domain
  value = "alt4.aspmx.l.google.com"
  type = "MX"
  priority = 10
}

resource "cloudflare_record" "email_verification" {
  zone_id = lookup(data.cloudflare_zones.website.zones[0], "id")
  name = var.domain
  value = "zdrsn22ndja5k3zpzli2oy3dsmfwdteuevwifa6d56vep64fgi6a.mx-verification.google.com"
  type = "MX"
  priority = 15
}

resource "cloudflare_record" "txt_verification" {
  zone_id = lookup(data.cloudflare_zones.website.zones[0], "id")
  name = var.domain
  value = "google-site-verification=yOMm600aQdVvL8rRp2NjkwthzJQlbIKDw--qR_uFMjw"
  type = "TXT"
}
