terraform {
  required_version = "~>1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }

  backend "s3" {
    key = "cloudfront/TENANT/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "TENANT_cloudfront_distribution" {
  source                       = "git@gitlab.iplit.in:devops/terraform-modules/cloudfront-s3-cdn.git?ref=1.0.2"
  tenant_name                  = "TENANT"
  application_dns_name         = "prod-ingress-nlb.bahmnilite.in"
  webapp_domain_name           = "TENANT.bahmnilite.in"
  static_files_folder          = "static"
  static_content_path_prefixes = ["/bahmni/*.png", "/bahmni/*.css", "/bahmni/*.js", "/index.html", "/bahmni/error_pages/*"]
  webapp_acm_certificate_arn   = "CERTIFICATE_ARN"
  maintenance_page_origin      = "bahmnilite-maintenance-page"
}

output "cloudfront_distribution_domain_name" {
  value = module.TENANT_cloudfront_distribution.cloudfront_distribution_domain_name
}
