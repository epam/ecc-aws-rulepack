class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        resource0 = list(filter(lambda r: r['GroupName'] == 'c7n-test', resources))[0]
        resource1 = list(filter(lambda r: r['GroupName'] == 'c7n-test2', resources))[0]
        base_test.assertEqual(resource0['IpPermissions'][0]['IpProtocol'], '-1')
        base_test.assertEqual(resource1['IpPermissions'][0]['FromPort'], 0)
        base_test.assertEqual(resource1['IpPermissions'][0]['ToPort'], 65535)