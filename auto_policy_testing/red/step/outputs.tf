output "step" {
  value = {
    step-machine = aws_sfn_state_machine.this.arn
  }
}
