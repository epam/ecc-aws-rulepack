output "ecs" {
  value = {
    ecs = aws_ecs_cluster.this.id
    ecs-service = aws_ecs_service.this.id
    ecs-task-definition = aws_ecs_task_definition.this.arn 
  }
}
