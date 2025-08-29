class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        ds = local_session.client("ds").describe_directories()
        subnet_settings = resources[0].get('SubnetIds')
        vpc = ds['DirectoryDescriptions'][0]['VpcSettings']['VpcId']

        endpoint = local_session.client("ec2").describe_vpc_endpoints(Filters=[{'Name': 'vpc-id', 'Values': [vpc]}])
        base_test.assertEqual(endpoint["VpcEndpoints"], [])
        base_test.assertFalse(all(subnet_id in endpoint.get('SubnetIds', []) for subnet_id in subnet_settings))
