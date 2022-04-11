# Elastic Cloud AWS PrivateLink module

This module is an easy-to-use module for creating an Elastic Cloud deployment that connects to an existing AWS VPC via PrivateLink.

## Usage

This example will deploy a small elasticsearch cluster on us-east-1 that can be reached via PrivateLink from the VPC provided
given that the ingress_cidr and subnet_ids provided are correct.

For more information see: https://registry.terraform.io/modules/math280h/cloud-private-link-aws/elastic/latest

````terraform
provider "ec" {
    apikey = var.elastic_cloud_api_key
}

data "ec_stack" "latest" {
    version_regex = "latest"
    region        = "us-east-1"
}

module "elastic_cloud" {
    source  = "math280h/cloud-private-link-aws/elastic"
    version = "0.0.1"

    vpc_id = "some-vpc-id"
    ingress_cidr = ["192.168.0.0/32"]
    subnet_ids = ["<subnet-id-one>", "<subnet-id-two>"]
    
    deployment_name = "my-elastic-cloud-deployment"
    deployment_version = data.ec_stack.latest.version
}
````
