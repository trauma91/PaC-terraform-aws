output "cloud_front_domain" {
    value = aws_cloudfront_distribution.frontend_cloudfront_distribution.domain_name
}

output "lb_dns" {
    value = aws_alb.be_load_balancer.dns_name
}

output "ecr_repo" {
    value = aws_ecr_repository.ecr_empatica.repository_url
}

output "s3_bucket" {
    value = aws_s3_bucket.empatica-fe-static.bucket
}

output "cluster_name" {
    value = aws_ecs_cluster.cpalese_empatica.name
}

output "service_name" {
    value = aws_ecs_service.backend_service.name
}

output "rds_db" {
    value = aws_db_instance.empatica_db.address
}