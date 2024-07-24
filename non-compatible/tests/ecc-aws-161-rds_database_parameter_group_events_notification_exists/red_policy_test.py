class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        rds_client = local_session.client("rds")
        rds_subscription = rds_client.describe_event_subscriptions(SubscriptionName="db-event-subscription-161-red")['EventSubscriptionsList'][0]
        base_test.assertTrue(rds_subscription['Enabled'])
        base_test.assertEqual(rds_subscription['SourceType'], "db-parameter-group")
        base_test.assertTrue('db-parameter-group-161-red' in rds_subscription['SourceIdsList'])