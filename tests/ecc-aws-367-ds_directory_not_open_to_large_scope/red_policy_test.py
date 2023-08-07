class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        ec2_client = local_session.client("ec2")  
        security_goups = ec2_client.describe_security_groups(GroupIds=resources[0]["c7n:matched-security-groups"])
        base_test.assertEqual(security_goups["SecurityGroups"][0]["IpPermissions"][0]["IpRanges"][0]["CidrIp"], "0.0.0.0/0")
        base_test.assertListEqual(security_goups["SecurityGroups"][0]["IpPermissions"][0]["UserIdGroupPairs"], [])