variable "aws_resource_name" {
    type        = string
    description = "The name used for objects on AWS"
    default     = "elastic-cloud-private-link-access"
}

variable "vpc_id" {
    type        = string
    description = "VPC ID"
}

variable "region" {
    type        = string
    description = "Deployment region. By default: us-east-1"
    default     = "us-east-1"
}

/**
* Security Group
**/

variable "ingress_cidr" {
    type        = list(string)
    description = "CIDR Blocks that are allowed to connect to elastic cloud via the VPC"
}

/**
* Private Link
**/

variable "service_name" {
    type        = string
    description = "The PrivateLink service name for your elastic cloud deployment. By default, us-east-1 (https://www.elastic.co/guide/en/cloud/current/ec-traffic-filtering-vpc.html)"
    default     = "com.amazonaws.vpce.us-east-1.vpce-svc-0e42e1e06ed010238"
}

variable "extra_security_groups" {
    type        = list(string)
    description = "Extra security groups attached to the VPCE for the PrivateLink"
    default     = [ ]
}

variable "subnet_ids" {
    type        = list(string)
    description = "ID's of the subnets to use for the VPCE. Be aware they MUST be in the supported AZ (https://www.elastic.co/guide/en/cloud/current/ec-traffic-filtering-vpc.html#ec-traffic-filtering-vpc)"
}

/**
* Route53
**/

variable "zone_name" {
    type        = string
    description = "Route53 zone name. By default: us-east-1"
    default     = "vpce.us-east-1.aws.elastic-cloud.com"
}

variable "record_ttl" {
    type        = string
    description = "TTL for the Route53 Record. By default: 300"
    default     = "300"
}

/**
* Traffic Filter
**/

variable "filter_name" {
    type        = string
    description = "Name for the traffic filter on elastic cloud"
    default     = "Allow traffic from AWS VPC"
}

/**
* Elastic cloud deployment
**/

variable "deployment_name" {
    type        = string
    description = "The name of the elastic cloud deployment"
}

variable "deployment_version" {
    type        = string
    description = "Version of the elastic deployment. (https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/ec_stack)"
}

variable "deployment_template" {
    type        = string
    description = "Deployment template ID. (https://www.elastic.co/guide/en/cloud-enterprise/current/ece-deployment-templates.html)"
    default     = "aws-io-optimized-v2"
}

variable "extra_traffic_filters" {
    type        = list(string)
    description = "Extra traffic filters to attach to deployment"
    default     = [ ]
}

variable "elasticsearch_topology" {
    type        = object({})
    description = "Elasticsearch topology"
    default     = {
        id         = "hot_content"
        zone_count = 2
        size       = "8g"
    }
}

variable "kibana_topology" {
    type        = object({})
    description = "Kibana topology"
    default     = {
        size = "2g"
    }
}