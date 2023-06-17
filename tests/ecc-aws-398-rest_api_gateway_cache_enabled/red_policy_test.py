class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertFalse(resources[0]['cacheClusterEnabled'])
        base_test.assertEqual(resources[0]['cacheClusterStatus'], "NOT_AVAILABLE")