class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        sg = local_session.client("ec2").describe_security_groups(Filters=[{'Name': 'group-name', 'Values': ['workstation_security_group']}])
        base_test.assertEqual(sg['SecurityGroups'][0]['IpPermissions'][0]['IpProtocol'],'-1')
        base_test.assertEqual(sg['SecurityGroups'][0]['IpPermissions'][0]['IpRanges'][0]['CidrIp'],'0.0.0.0/0')
        base_test.assertNotIn('FromPort',sg['SecurityGroups'][0]['IpPermissions'][0])
        
