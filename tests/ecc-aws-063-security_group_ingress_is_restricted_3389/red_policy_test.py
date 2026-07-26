class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            sorted([r['GroupId'] for r in resources]),
            sorted(['sg-0cebf5524a225a4b7', 'sg-0cebf5524a225a4ba']),
        )
        for r in resources:
            base_test.assertEqual(r['IpPermissions'][0]['IpProtocol'], 'tcp')
            base_test.assertEqual(r['IpPermissions'][0]['ToPort'], 3389)
            base_test.assertEqual(r['IpPermissions'][0]['FromPort'], 3389)
            base_test.assertEqual(r['IpPermissions'][0]['Ipv6Ranges'][0]['CidrIpv6'], '::/0')


class PolicyTest_SpecificGroup(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['GroupId'], 'sg-0cebf5524a225a4b7')


class PolicyTest_NoFoundGroups(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
