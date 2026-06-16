class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            sorted([r['GroupId'] for r in resources]),
            sorted(['sg-123412b1225fc12de', 'sg-123412b1225fc12df']),
        )
        for r in resources:
            base_test.assertEqual(r['IpPermissions'][0]['ToPort'], 53)
            base_test.assertEqual(r['IpPermissions'][0]['FromPort'], 53)
            base_test.assertEqual(r['IpPermissions'][0]['IpProtocol'], 'tcp')
            base_test.assertEqual(r['IpPermissions'][0]['IpRanges'][0]['CidrIp'], '0.0.0.0/0')


class PolicyTest_SpecificGroup(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['GroupId'], 'sg-123412b1225fc12de')
        base_test.assertEqual(resources[0]['IpPermissions'][0]['ToPort'], 53)
        base_test.assertEqual(resources[0]['IpPermissions'][0]['FromPort'], 53)
        base_test.assertEqual(resources[0]['IpPermissions'][0]['IpProtocol'], 'tcp')
        base_test.assertEqual(resources[0]['IpPermissions'][0]['IpRanges'][0]['CidrIp'], '0.0.0.0/0')


class PolicyTest_NoFoundGroups(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
