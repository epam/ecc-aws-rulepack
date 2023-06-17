class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['IpPermissions'][0]['ToPort'], 5601)
        base_test.assertEqual(resources[0]['IpPermissions'][0]['IpRanges'][0]['CidrIp'], '0.0.0.0/0')