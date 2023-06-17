class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertTrue(resources[0]['c7n:credential-report']['access_keys'][0]['last_used_date'])
        base_test.assertTrue(resources[0]['c7n:credential-report']['password_last_used'])

        
