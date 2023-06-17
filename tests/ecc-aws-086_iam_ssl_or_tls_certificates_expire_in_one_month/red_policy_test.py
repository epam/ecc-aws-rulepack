class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(str(resources[0]['Expiration']), '2021-06-18 13:32:22+00:00')
        
