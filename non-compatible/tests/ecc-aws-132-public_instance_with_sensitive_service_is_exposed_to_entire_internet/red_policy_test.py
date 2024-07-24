
class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        security_group_1 = local_session.client("ec2").describe_security_groups()["SecurityGroups"][0]
        security_group_2 = local_session.client("ec2").describe_security_groups()["SecurityGroups"][1]
        ec2Instance1 = resources[0]['SecurityGroups'][0]['GroupId']
        ec2Instance2 = resources[0]['SecurityGroups'][1]['GroupId']
        ec2_list = []
        ec2_list.extend([ec2Instance1, ec2Instance2])
        base_test.assertIn(security_group_1['GroupId'], ec2_list)
        base_test.assertIn(security_group_2['GroupId'], ec2_list)
        base_test.assertEqual(security_group_1['IpPermissions'][0]['FromPort'], 4505)
        base_test.assertEqual(security_group_1['IpPermissions'][0]['IpRanges'][0]['CidrIp'], "0.0.0.0/0")
        base_test.assertEqual(security_group_2['IpPermissions'][0]['FromPort'], 8000)
        base_test.assertEqual(security_group_2['IpPermissions'][0]['IpRanges'][0]['CidrIp'], "0.0.0.0/0")
        base_test.assertEqual(security_group_2['IpPermissions'][1]['FromPort'], 5500)
        base_test.assertEqual(security_group_2['IpPermissions'][1]['IpRanges'][0]['CidrIp'], "0.0.0.0/0")