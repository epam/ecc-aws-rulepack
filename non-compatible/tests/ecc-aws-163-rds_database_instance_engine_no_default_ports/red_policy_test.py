class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        ec2Group = local_session.client("ec2").describe_security_groups()["SecurityGroups"]
        newGroup = ec2Group[0]['GroupId']
        dbGroup = (resources[0]['VpcSecurityGroups'][0]['VpcSecurityGroupId'])
        base_test.assertEqual(ec2Group[0]['IpPermissions'][0]['FromPort'], 3306)
        base_test.assertEqual(resources[0]['Endpoint']['Port'], 3306)
        base_test.assertEqual(dbGroup, newGroup)