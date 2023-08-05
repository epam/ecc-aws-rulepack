class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        vpc_id = resources[0]['VpcId']
        vpc_endpoints = local_session.client("ec2").describe_vpc_endpoints(Filters=[{'Name':'vpc-id','Values':[vpc_id]}])
        base_test.assertNotEqual(vpc_endpoints['VpcEndpoints'][0]['ServiceName'],'com.amazonaws.us-east-1.ec2')