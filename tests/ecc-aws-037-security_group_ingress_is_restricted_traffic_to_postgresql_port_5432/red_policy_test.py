class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            sorted([r['GroupId'] for r in resources]),
            sorted(['sg-0e24cbbe76e4a9028', 'sg-0e24cbbe76e4a9038']),
        )
        for r in resources:
            base_test.assertEqual(r['IpPermissions'][0]['ToPort'], 5432)
            base_test.assertEqual(r['IpPermissions'][0]['FromPort'], 5432)
            base_test.assertEqual(r['IpPermissions'][0]['IpProtocol'], 'tcp')
            base_test.assertEqual(r['IpPermissions'][0]['IpRanges'][0]['CidrIp'], '0.0.0.0/0')


class PolicyTest_SpecificGroup(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['GroupId'], 'sg-0e24cbbe76e4a9028')
        base_test.assertEqual(resources[0]['IpPermissions'][0]['ToPort'], 5432)
        base_test.assertEqual(resources[0]['IpPermissions'][0]['FromPort'], 5432)
        base_test.assertEqual(resources[0]['IpPermissions'][0]['IpProtocol'], 'tcp')
        base_test.assertEqual(resources[0]['IpPermissions'][0]['IpRanges'][0]['CidrIp'], '0.0.0.0/0')


class PolicyTest_NoFoundGroups(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
