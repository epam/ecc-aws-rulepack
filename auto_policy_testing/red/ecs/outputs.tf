output "ecs" {
  value = {
    ecs = aws_ecs_cluster.this1.arn
    ecc-aws-110-ecs_cluster_at_rest_encryption = aws_ecs_cluster.this2.arn
    ecc-aws-464-ecs_exec_logging_enabled = aws_ecs_cluster.this2.arn
    ecc-aws-582-ecs_service_placement_strategy = [aws_ecs_cluster.this1.arn, aws_ecs_cluster.this2.arn]
    
    ecs-service = aws_ecs_service.this1.id
    ecc-aws-118-ecs_cluster_have_empty_roles_for_service_task_definitions = aws_ecs_service.this5.id
    ecc-aws-582-ecs_service_placement_strategy = aws_ecs_service.this2.id

    ecs-task-definition = aws_ecs_task_definition.this2.arn
    ecc-aws-190-ecs_task_definitions_secure_networking_modes_and_user_definitions = [aws_ecs_task_definition.this2.arn, aws_ecs_task_definition.this3.arn]
    ecc-aws-537-ecs_containers_nonprivileged = aws_ecs_task_definition.this4.arn
  }
}
