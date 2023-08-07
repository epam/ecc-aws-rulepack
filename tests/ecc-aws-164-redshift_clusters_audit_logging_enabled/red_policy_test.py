class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        client = local_session.client("redshift")
        redshift_id = resources[0]['ClusterIdentifier']
        result = client.describe_logging_status(
            ClusterIdentifier=redshift_id)
        base_test.assertFalse(result["LoggingEnabled"])
        paramName = resources[0]['ClusterParameterGroups'][0]['ParameterGroupName']
        param = local_session.client("redshift").describe_cluster_parameters(ParameterGroupName=paramName)
        parameters=param["Parameters"]
        for parameter in parameters:
          if parameter["ParameterName"]=="enable_user_activity_logging":
             base_test.assertEqual(parameter['ParameterValue'], 'false')