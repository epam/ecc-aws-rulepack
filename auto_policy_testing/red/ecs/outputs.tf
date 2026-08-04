output "ecs" {
  value = {
    ecs                                               = aws_ecs_cluster.this.arn
    ecc-aws-464-ecs_exec_logging_enabled              = aws_ecs_cluster.no_exec_logging.arn
    ecs-service                                       = aws_ecs_service.this.id
    ecc-aws-494-ecs_fargate_latest_platform_version   = aws_ecs_service.this.id
    ecc-aws-582-ecs_service_placement_strategy        = aws_ecs_service.placement.id
    ecs-task-definition                               = aws_ecs_task_definition.no_memory_limit.arn
    ecc-aws-495-ecs_task_definition_memory_hard_limit = aws_ecs_task_definition.no_memory_limit.arn
    ecc-aws-496-ecs_task_definition_pid_mode_check    = aws_ecs_task_definition.pid_host_secrets.arn
    ecc-aws-522-ecs_no_environment_secrets            = aws_ecs_task_definition.pid_host_secrets.arn
    ecc-aws-537-ecs_containers_nonprivileged          = aws_ecs_task_definition.privileged.arn
  }
}
