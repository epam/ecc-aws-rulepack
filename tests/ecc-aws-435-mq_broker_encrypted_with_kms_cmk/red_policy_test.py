def _assert_kms_not_customer_managed(base_test, r, local_session):
    key_raw = r['EncryptionOptions']['KmsKeyId']
    key_id = key_raw.split('/')
    kms = local_session.client("kms").describe_key(KeyId=key_id[1])
    base_test.assertEqual(kms['KeyMetadata']['KeyManager'], 'AWS')


class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['BrokerArn'] for r in resources],
            [
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-435-red:b-8fe42657-d316-4dcf-a301-c3c04106e7f4',
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-435-red-b-b:b-8fe42657-d316-4dcf-a301-c3c04106e7f3',
            ],
        )
        for r in resources:
            _assert_kms_not_customer_managed(base_test, r, local_session)


class PolicyTest_SpecificBroker(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['BrokerArn'],
            'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-435-red:b-8fe42657-d316-4dcf-a301-c3c04106e7f4',
        )
        _assert_kms_not_customer_managed(base_test, resources[0], local_session)


class PolicyTest_NoFoundBrokers(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
