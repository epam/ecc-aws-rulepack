class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertFalse(resources[0]['c7n:credential-report']['access_keys'][0]['active'])