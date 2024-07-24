class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        ec2 = local_session.client("ec2").describe_security_groups()
        base_test.assertEqual(ec2['SecurityGroups'][0]['IpPermissions'][0]['IpRanges'][0]['CidrIp'], "0.0.0.0/0")
