class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotRegex(resources[0]['Name'], r'^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$')