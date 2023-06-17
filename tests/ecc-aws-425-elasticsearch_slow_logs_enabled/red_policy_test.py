class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertTrue(resources[0]['LogPublishingOptions']['SEARCH_SLOW_LOGS']['Enabled'])
        base_test.assertNotIn('INDEX_SLOW_LOGS', resources[0]['LogPublishingOptions'])
        