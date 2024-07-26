class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertGreaterEqual(resources[0]['ProvisionedThroughput']['ReadCapacityUnits'],1)
        
        autoscaling_client = local_session.client("application-autoscaling")
        table_name = 'table/'+resources[0]['TableName']
        autoscaling = autoscaling_client.describe_scalable_targets(ServiceNamespace='dynamodb',ResourceIds=[table_name])['ScalableTargets']
        base_test.assertEqual(autoscaling,[])