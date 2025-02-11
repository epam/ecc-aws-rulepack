class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['IpPermissions'][0]['IpProtocol'], 'tcp')
        base_test.assertEqual(resources[0]['IpPermissions'][0]['ToPort'], 3389)
        base_test.assertEqual(resources[0]['IpPermissions'][0]['FromPort'], 3389)
        base_test.assertEqual(resources[0]['IpPermissions'][0]['Ipv6Ranges'][0]['CidrIpv6'], '::/0')