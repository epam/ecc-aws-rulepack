class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['c7n:AccessKeys'][0]['Status'], "Active")
        base_test.assertEqual(resources[0]['c7n:AccessKeys'][1]['Status'], "Active")