class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        subnet_group = local_session.client("elasticache").describe_cache_subnet_groups()['CacheSubnetGroups']
        vpc = local_session.client("ec2").describe_vpcs()['Vpcs']

        base_test.assertEqual(resources[0]['CacheSubnetGroupName'], "default")
        base_test.assertEqual(vpc[0]['VpcId'], subnet_group[0]['VpcId'])
        base_test.assertTrue(vpc[0]['IsDefault'])
        base_test.assertEqual(resources[0]['CacheSubnetGroupName'], subnet_group[0]['CacheSubnetGroupName'])