class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        ec2_client = local_session.client("ec2")
        security_goups = ec2_client.describe_security_groups(GroupIds=resources[0]["SecurityGroups"][0].split())
        base_test.assertNotEqual(security_goups["SecurityGroups"][0]["IpPermissions"][0]["FromPort"], "8162")
        base_test.assertNotEqual(security_goups["SecurityGroups"][0]["IpPermissions"][0]["ToPort"], "8162")