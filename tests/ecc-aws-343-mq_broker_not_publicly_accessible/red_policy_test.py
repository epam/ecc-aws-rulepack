class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['BrokerArn'] for r in resources],
            [
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-343-red:b-6defee1a-5f5d-45c0-8713-d57166f68f2f',
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-343-red-b-b:b-6defee1a-5f5d-45c0-8713-d57166f68f2e',
            ],
        )
        for r in resources:
            base_test.assertTrue(r['PubliclyAccessible'])


class PolicyTest_SpecificBroker(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['BrokerArn'],
            'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-343-red:b-6defee1a-5f5d-45c0-8713-d57166f68f2f',
        )
        base_test.assertTrue(resources[0]['PubliclyAccessible'])


class PolicyTest_NoFoundBrokers(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
