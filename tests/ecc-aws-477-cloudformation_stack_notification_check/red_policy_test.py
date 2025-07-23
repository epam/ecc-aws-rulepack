class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        sns_arn = resources[0]['NotificationARNs'][0]
        sns = local_session.client("sns").get_topic_attributes(TopicArn=sns_arn)
        base_test.assertEqual(sns["Attributes"]["SubscriptionsConfirmed"], "0")