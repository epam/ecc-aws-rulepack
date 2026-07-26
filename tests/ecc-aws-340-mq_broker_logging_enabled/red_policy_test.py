class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['BrokerArn'] for r in resources],
            [
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-340-red:b-27cea85d-a028-405a-925f-755e4ba36285',
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-340-red-b-b:b-27cea85d-a028-405a-925f-755e4ba36284',
            ],
        )
        for r in resources:
            base_test.assertFalse(r['Logs']['Audit'])
            base_test.assertFalse(r['Logs']['General'])


class PolicyTest_SpecificBroker(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['BrokerArn'],
            'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-340-red:b-27cea85d-a028-405a-925f-755e4ba36285',
        )
        base_test.assertFalse(resources[0]['Logs']['Audit'])
        base_test.assertFalse(resources[0]['Logs']['General'])


class PolicyTest_NoFoundBrokers(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
