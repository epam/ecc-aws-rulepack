class PolicyTest(object):
 
   def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]["ProvisionedThroughput"]["ReadCapacityUnits"], 1)
        base_test.assertEqual(resources[0]["TableStatus"], "ACTIVE")
        base_test.assertIn("CreationDateTime", resources[0]["c7n:MatchedFilters"])
        base_test.assertEqual(resources[0]["ItemCount"], 0)
        base_test.assertEqual(resources[0]["c7n.metrics"]["AWS/DynamoDB.ConsumedWriteCapacityUnits.Maximum.60"][0]["Maximum"], 0.0)
        base_test.assertEqual(resources[0]["c7n.metrics"]["AWS/DynamoDB.ConsumedReadCapacityUnits.Maximum.60"][0]["Maximum"], 0.0)
        