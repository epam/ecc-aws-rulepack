class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['BrokerArn'] for r in resources],
            [
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-339-red:b-11770e45-f1df-483e-8ea5-9dfda5f578b9',
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-339-red-b-b:b-11770e45-f1df-483e-8ea5-9dfda5f578b8',
            ],
        )
        for r in resources:
            base_test.assertFalse(r['AutoMinorVersionUpgrade'])


class PolicyTest_SpecificBroker(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['BrokerArn'],
            'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-339-red:b-11770e45-f1df-483e-8ea5-9dfda5f578b9',
        )
        base_test.assertFalse(resources[0]['AutoMinorVersionUpgrade'])


class PolicyTest_NoFoundBrokers(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
