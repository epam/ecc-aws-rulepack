class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        rds_client = local_session.client("rds")
        rds_subscription = rds_client.describe_event_subscriptions(SubscriptionName="db-event-subscription-159-red")['EventSubscriptionsList'][0]
        base_test.assertTrue(rds_subscription['Enabled'])
        base_test.assertNotIn('SourceIdsList', rds_subscription)
        base_test.assertEqual(rds_subscription['SourceType'], "db-cluster")
        base_test.assertTrue('failure' in rds_subscription['EventCategoriesList'])
        base_test.assertFalse('maintenance' in rds_subscription['EventCategoriesList'])
        
        sns_client = local_session.client("sns")
        subscriptions = sns_client.get_topic_attributes(TopicArn = "arn:aws:sns:us-east-1:644160558196:159-sns-topic-red")['Attributes']['SubscriptionsConfirmed']
        base_test.assertEqual('0', subscriptions)
        