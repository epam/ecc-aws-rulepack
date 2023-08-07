class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertTrue(resources[0]['resourcesVpcConfig']['endpointPublicAccess'])
        base_test.assertEqual(resources[0]['resourcesVpcConfig']['publicAccessCidrs'], ['0.0.0.0/0'])