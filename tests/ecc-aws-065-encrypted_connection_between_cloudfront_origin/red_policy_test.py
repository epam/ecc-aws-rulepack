class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:cloudfront::1212121112212:distribution/1212121112212',
                'arn:aws:cloudfront::1212121112212:distribution/2323232323232',
            ],
        )
        for r in resources:
            base_test.assertEqual(
                r['Origins']['Items'][0]['CustomOriginConfig']['OriginProtocolPolicy'],
                'http-only',
            )
            base_test.assertEqual(r['DefaultCacheBehavior']['ViewerProtocolPolicy'], 'allow-all')


class PolicyTest_SpecificDistribution(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:cloudfront::1212121112212:distribution/1212121112212',
        )
        base_test.assertEqual(
            resources[0]['Origins']['Items'][0]['CustomOriginConfig']['OriginProtocolPolicy'],
            'http-only',
        )
        base_test.assertEqual(
            resources[0]['DefaultCacheBehavior']['ViewerProtocolPolicy'],
            'allow-all',
        )


class PolicyTest_NoFoundDistributions(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
