class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        ds = local_session.client("ds").describe_directories()
        vpc = ds['DirectoryDescriptions'][0]['VpcSettings']['VpcId']

        endpoint = local_session.client("ec2").describe_vpc_endpoints(Filters=[{'Name': 'vpc-id', 'Values': [vpc]}])
        base_test.assertEqual(endpoint["VpcEndpoints"], [])

        
