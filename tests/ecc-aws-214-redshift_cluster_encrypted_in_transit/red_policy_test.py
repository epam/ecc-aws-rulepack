class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        localGroup = resources[0]['ClusterParameterGroups'][0]['ParameterGroupName']
        paramGroup = local_session.client("redshift").describe_cluster_parameters(ParameterGroupName = localGroup)["Parameters"][8]
        base_test.assertEqual(paramGroup['ParameterValue'], "false")