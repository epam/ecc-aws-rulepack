class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['BrokerArn'] for r in resources],
            [
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-active-433-red:b-dbd9cf80-6664-47c8-8774-2bbddc89b13b',
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-active-433-red-b-b:b-dbd9cf80-6664-47c8-8774-2bbddc89b13a',
            ],
        )
        for r in resources:
            base_test.assertEqual(r['DeploymentMode'], 'SINGLE_INSTANCE')


class PolicyTest_SpecificBroker(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['BrokerArn'],
            'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-active-433-red:b-dbd9cf80-6664-47c8-8774-2bbddc89b13b',
        )
        base_test.assertEqual(resources[0]['DeploymentMode'], 'SINGLE_INSTANCE')


class PolicyTest_NoFoundBrokers(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
