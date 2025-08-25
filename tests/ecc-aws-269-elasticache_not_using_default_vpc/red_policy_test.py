class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        subnet_group = local_session.client("elasticache").describe_cache_subnet_groups(CacheSubnetGroupName=resources[0]['CacheSubnetGroupName'])['CacheSubnetGroups']
        vpc = local_session.client("ec2").describe_vpcs(VpcIds=[subnet_group[0]['VpcId']])['Vpcs']

        base_test.assertEqual(resources[0]['CacheSubnetGroupName'], "default")
        base_test.assertTrue(vpc[0]['IsDefault'])