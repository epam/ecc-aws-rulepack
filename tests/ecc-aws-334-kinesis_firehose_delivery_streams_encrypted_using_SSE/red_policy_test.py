def _assert_sse_disabled(base_test, r):
    base_test.assertEqual(
        r['DeliveryStreamEncryptionConfiguration']['Status'],
        'DISABLED',
    )


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['DeliveryStreamARN'] for r in resources],
            [
                'arn:aws:firehose:us-east-1:111111111111:deliverystream/334_kinesis_firehose_red',
                'arn:aws:firehose:us-east-1:111111111111:deliverystream/334_kinesis_firehose_red_b',
            ],
        )
        for r in resources:
            _assert_sse_disabled(base_test, r)


class PolicyTest_SpecificDeliveryStream(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['DeliveryStreamARN'],
            'arn:aws:firehose:us-east-1:111111111111:deliverystream/334_kinesis_firehose_red',
        )
        _assert_sse_disabled(base_test, resources[0])


class PolicyTest_NoFoundDeliveryStreams(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
