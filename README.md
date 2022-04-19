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

Once deployed, the elastic deployment is reachable via the following link (On 443): `https://<name-of-elastic-deployment>.es.vpce.<region>.aws.elastic-cloud.com`

### AWS VPC Configuration

For this to work, you must have the DNS Hostnames and DNS Resolution enabled on your VPC. (https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#vpc-dns-updating)

## Resources
https://www.elastic.co/guide/en/cloud/current/ec-traffic-filtering-vpc.html
https://aws.amazon.com/premiumsupport/knowledge-center/route-53-fix-dns-resolution-issues/
