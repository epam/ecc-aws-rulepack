class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotIn('Protocol-TLSv1.2', resources[0]['ProhibitedPolicies'])

        
