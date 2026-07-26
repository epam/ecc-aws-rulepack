class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            sorted([r['GroupId'] for r in resources]),
            sorted(['sg-0cebf5524a225a4b7', 'sg-0cebf5524a225a4b9']),
        )
        for r in resources:
            base_test.assertEqual(r['IpPermissions'][0]['IpProtocol'], 'tcp')
            base_test.assertLessEqual(r['IpPermissions'][0]['FromPort'], 1521)
            base_test.assertGreaterEqual(r['IpPermissions'][0]['ToPort'], 2483)
            base_test.assertEqual(r['IpPermissions'][0]['Ipv6Ranges'][0]['CidrIpv6'], '::/0')


class PolicyTest_SpecificGroup(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['GroupId'], 'sg-0cebf5524a225a4b7')
        base_test.assertEqual(resources[0]['IpPermissions'][0]['IpProtocol'], 'tcp')
        base_test.assertLessEqual(resources[0]['IpPermissions'][0]['FromPort'], 1521)
        base_test.assertGreaterEqual(resources[0]['IpPermissions'][0]['ToPort'], 2483)
        base_test.assertEqual(resources[0]['IpPermissions'][0]['Ipv6Ranges'][0]['CidrIpv6'], '::/0')


class PolicyTest_NoFoundGroups(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
