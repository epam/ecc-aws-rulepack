class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0] ['IpPermissionsEgress'][0] ['Ipv6Ranges'][0] ['CidrIpv6'], '::/0')
        base_test.assertEqual(resources[0] ['IpPermissionsEgress'][0] ['IpProtocol'], '-1')