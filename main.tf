terraform {
    required_version = ">= 0.12.29"

    required_providers {
        ec = {
            source  = "elastic/ec"
            version = "0.4.0"
        }
    }
}

/**
* AWS
**/

resource "aws_security_group" "private-link" {
    name   = var.aws_resource_name
    vpc_id = var.vpc_id

    ingress {
        description = "Allow HTTPS to elastic cloud deployment"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = var.ingress_cidr
    }

    tags = {
        Name = var.aws_resource_name
    }
}

resource "aws_vpc_endpoint" "private-link" {
    service_name = var.service_name

    vpc_id            = var.vpc_id
    vpc_endpoint_type = "Interface"

    security_group_ids = merge([ aws_security_group.private-link.id ], var.extra_security_groups)
    subnet_ids         = var.subnet_ids

    tags = {
        Name = var.aws_resource_name
    }

    depends_on = [ aws_security_group.private-link ]
}

resource "aws_route53_zone" "private-link" {
    name = var.zone_name

    vpc {
        vpc_id = var.vpc_id
    }
}

resource "aws_route53_record" "private-link" {
    zone_id = aws_route53_zone.private-link.zone_id

    name    = "*"
    type    = "CNAME"
    records = [ lookup(aws_vpc_endpoint.private-link.dns_entry[ 0 ], "dns_name") ]

    ttl = var.record_ttl

    depends_on = [ aws_route53_zone.private-link ]
}

/**
* Elastic cloud
**/

resource "ec_deployment_traffic_filter" "deployment_filter" {
    name   = var.filter_name
    region = var.region
    type   = "vpce"

    rule {
        source = aws_vpc_endpoint.private-link.id
    }

    depends_on = [ aws_vpc_endpoint.private-link ]
}

resource "ec_deployment" "deployment" {
    name   = var.deployment_name
    region = var.region

    version                = var.deployment_version
    deployment_template_id = var.deployment_template

    traffic_filter = merge([ ec_deployment_traffic_filter.deployment_filter.id ], var.extra_traffic_filters)

    elasticsearch {
        topology {
            id = var.elasticsearch_topology.id

            zone_count = var.elasticsearch_topology.zone_count
            size       = var.elasticsearch_topology.size
        }
    }

    kibana {
        topology {
            size = var.kibana_topology.size
        }
    }
}
