class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['MetadataOptions']['HttpEndpoint'], 'enabled')
        base_test.assertEqual(resources[0]['MetadataOptions']['HttpTokens'], 'optional')
        base_test.assertEqual(resources[0]['MetadataOptions']['State'], 'applied')