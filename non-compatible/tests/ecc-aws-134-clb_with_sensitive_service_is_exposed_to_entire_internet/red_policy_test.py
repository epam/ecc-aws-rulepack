class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        security_group_1 = local_session.client("ec2").describe_security_groups()["SecurityGroups"][0]
        security_group_2 = local_session.client("ec2").describe_security_groups()["SecurityGroups"][1]
        elb_group = resources[0]['SecurityGroups']
        base_test.assertIn(security_group_1['GroupId'], elb_group)
        base_test.assertIn(security_group_2['GroupId'], elb_group)
        base_test.assertEqual(security_group_1['IpPermissions'][0]['FromPort'], 110)
        base_test.assertEqual(security_group_1['IpPermissions'][0]['IpRanges'][0]['CidrIp'], "0.0.0.0/0")
        base_test.assertEqual(security_group_1['IpPermissions'][1]['FromPort'], 25)
        base_test.assertEqual(security_group_1['IpPermissions'][1]['IpRanges'][0]['CidrIp'], "0.0.0.0/0")
        base_test.assertEqual(security_group_2['IpPermissions'][0]['FromPort'], 23)
        base_test.assertEqual(security_group_2['IpPermissions'][0]['IpRanges'][0]['CidrIp'], "0.0.0.0/0")
