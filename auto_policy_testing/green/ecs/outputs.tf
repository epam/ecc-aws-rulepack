output "ecs" {
  value = {
    ecs = aws_ecs_cluster.this.id
    ecs-service = aws_ecs_service.this.id
    ecs-task-definition = aws_ecs_task_definition.this.arn 
    ecc-aws-521-ecs_containers_readonly_access_AND_ecc-aws-495-ecs_task_definition_memory_hard_limit = aws_ecs_task_definition.this2.arn 
  }
}
