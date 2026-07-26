class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['StackId'] for r in resources],
            [
                'arn:aws:cloudformation:us-east-1:644160558196:stack/stack-477-red1/8f27019d0b',
                'arn:aws:cloudformation:us-east-1:644160558196:stack/stack-477-red2/2222222222',
            ],
        )
        for r in resources:
            sns_arn = r['NotificationARNs'][0]
            sns = local_session.client("sns").get_topic_attributes(TopicArn=sns_arn)
            base_test.assertEqual(sns["Attributes"]["SubscriptionsConfirmed"], "0")


class PolicyTest_SpecificStack(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['StackId'],
            'arn:aws:cloudformation:us-east-1:644160558196:stack/stack-477-red1/8f27019d0b',
        )
        sns_arn = resources[0]['NotificationARNs'][0]
        sns = local_session.client("sns").get_topic_attributes(TopicArn=sns_arn)
        base_test.assertEqual(sns["Attributes"]["SubscriptionsConfirmed"], "0")


class PolicyTest_NoFoundStacks(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
