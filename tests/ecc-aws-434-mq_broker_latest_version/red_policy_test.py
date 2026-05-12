class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['BrokerArn'] for r in resources],
            [
                'arn:aws:mq:us-east-1:644160558196:broker:mq-broker-rabbit-434-red:b-ef5d7457-a11c-43a9-bb15-ab9ff7bdd1ec',
                'arn:aws:mq:us-east-1:644160558196:broker:mq-broker-rabbit-434-red-b:b-ef5d7457-a11c-43a9-bb15-ab9ff7bdd1eb',
            ],
        )
        for r in resources:
            base_test.assertEqual(r['EngineType'], 'RabbitMQ')
            base_test.assertNotRegex(r['EngineVersion'], '3.13.*')


class PolicyTest_SpecificBroker(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['BrokerArn'],
            'arn:aws:mq:us-east-1:644160558196:broker:mq-broker-rabbit-434-red:b-ef5d7457-a11c-43a9-bb15-ab9ff7bdd1ec',
        )
        base_test.assertEqual(resources[0]['EngineType'], 'RabbitMQ')
        base_test.assertNotRegex(resources[0]['EngineVersion'], '3.13.*')


class PolicyTest_NoFoundBrokers(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
