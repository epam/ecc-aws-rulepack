output "ecs" {
  value = {
    ecs = aws_ecs_cluster.this1.arn
    ecc-aws-360-ecs_exec_logging_encryption_enabled = [aws_ecs_cluster.this1.arn, aws_ecs_cluster.this2.arn]
    ecc-aws-464-ecs_exec_logging_enabled = [aws_ecs_cluster.this1.arn, aws_ecs_cluster.this2.arn]

    ecs-service = aws_ecs_service.this1.id
    ecc-aws-582-ecs_service_placement_strategy = [aws_ecs_service.this1.id, aws_ecs_service.this2.id]

    ecs-task-definition = aws_ecs_task_definition.this1.arn 
    ecc-aws-190-ecs_task_definitions_secure_networking_modes_and_user_definitions = [aws_ecs_task_definition.this1.arn, aws_ecs_task_definition.this2.arn]
    ecc-aws-496-ecs_task_definition_pid_mode_check = [aws_ecs_task_definition.this1.arn, aws_ecs_task_definition.this2.arn]
    ecc-aws-537-ecs_containers_nonprivileged = [aws_ecs_task_definition.this1.arn, aws_ecs_task_definition.this2.arn, aws_ecs_task_definition.this3.arn]
    }
}