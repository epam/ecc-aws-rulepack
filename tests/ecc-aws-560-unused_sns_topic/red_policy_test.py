class PolicyTest(object):
 
   def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]["SubscriptionsConfirmed"], "0")
        base_test.assertEqual(resources[0]["c7n.metrics"]["AWS/SNS.NumberOfMessagesPublished.Sum.30"][0]["Sum"], 0)
