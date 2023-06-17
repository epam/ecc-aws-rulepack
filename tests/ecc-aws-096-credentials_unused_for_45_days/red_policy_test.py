class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['c7n:credential-report']['password_last_used'], '2020-02-25T09:26:50+00:00')
        base_test.assertEqual(resources[0]['c7n:credential-report']['password_last_changed'], '2020-02-25T09:59:26+00:00')
        base_test.assertEqual(resources[0]['c7n:credential-report']['access_keys'][0]['last_used_date'], '2020-02-26T07:27:09+00:00')
        base_test.assertEqual(resources[0]['c7n:credential-report']['access_keys'][0]['last_rotated'], '2020-02-26T07:27:09+00:00')
        
        

