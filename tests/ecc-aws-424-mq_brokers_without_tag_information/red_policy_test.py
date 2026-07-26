class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['BrokerArn'] for r in resources],
            [
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-424-red:b-a21606c3-8aa2-48a5-8461-eb9631bb5bdd',
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-424-red-b-b:b-a21606c3-8aa2-48a5-8461-eb9631bb5bdc',
            ],
        )
        for r in resources:
            base_test.assertFalse(r['Tags'])


class PolicyTest_SpecificBroker(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['BrokerArn'],
            'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-424-red:b-a21606c3-8aa2-48a5-8461-eb9631bb5bdd',
        )
        base_test.assertFalse(resources[0]['Tags'])


class PolicyTest_NoFoundBrokers(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
