class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['c7n:ssm-compliance'][0]['Status'], 'NON_COMPLIANT')