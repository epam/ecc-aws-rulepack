output "event-bus" {
  value = {
    event-bus = aws_cloudwatch_event_bus.this.arn 
  }
}
