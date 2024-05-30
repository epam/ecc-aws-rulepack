class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        parameter_group_name=resources[0]["ClusterParameterGroups"][0]["ParameterGroupName"]
        describe_parameters = local_session.client("redshift").describe_cluster_parameters(ParameterGroupName=parameter_group_name)
        parameters=describe_parameters["Parameters"]

        for parameter in parameters:
          if parameter["ParameterName"]=="require_ssl":
             base_test.assertEqual(parameter['ParameterValue'], 'false')
             describe_parameters = local_session.client("redshift").describe_cluster_parameters(ParameterGroupName=parameter_group_name)