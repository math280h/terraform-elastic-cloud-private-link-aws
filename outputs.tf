output "aws_security_group_id" {
    value = aws_security_group.private-link.id
}

output "aws_vpc_endpoint_id" {
    value = aws_vpc_endpoint.private-link.id
}

output "aws_route53_zone" {
    value = aws_route53_zone.private-link.id
}

output "aws_route53_record" {
    value = aws_route53_record.private-link.id
}

output "ec_traffic_filter" {
    value = ec_deployment_traffic_filter.deployment_filter.id
}

output "ec_deployment" {
    value = ec_deployment.deployment.id
}
