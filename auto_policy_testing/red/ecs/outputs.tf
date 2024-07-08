output "ecs" {
  value = {
    ecs = aws_ecs_cluster.this1.id
    ecc-aws-464-ecs_exec_logging_enabled = [aws_ecs_cluster.this2.id]
    ecc-aws-582-ecs_service_placement_strategy = [aws_ecs_cluster.this1.id, aws_ecs_cluster.this2.id]
    
    ecs-service = aws_ecs_service.this1
    ecc-aws-582-ecs_service_placement_strategy = aws_ecs_service.this2

    ecs-task-definition = aws_ecs_task_definition.this2
    ecc-aws-190-ecs_task_definitions_secure_networking_modes_and_user_definitions = [aws_ecs_task_definition.this2, aws_ecs_task_definition.this3]
    ecc-aws-537-ecs_containers_nonprivileged = aws_ecs_task_definition.this4
  }
}
