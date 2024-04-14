output "apigwv2" {
  value = {
    apigwv2-stage = [
      {
        "c7n:parent-id" : element(split("/", aws_apigatewayv2_stage.this1.arn), 2)
        StageName : aws_apigatewayv2_stage.this1.id
      },
      {
        "c7n:parent-id" : element(split("/", aws_apigatewayv2_stage.this2.arn), 2)
        StageName : aws_apigatewayv2_stage.this2.id
      }
    ]
  }
}