class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:cloudfront::111111111111:distribution/E1X0H1C4VB45I8',
                'arn:aws:cloudfront::111111111111:distribution/E1X0H1C4VB45J9',
            ],
        )
        for r in resources:
            base_test.assertEqual(r['DefaultCacheBehavior']['ViewerProtocolPolicy'], 'allow-all')


class PolicyTest_SpecificDistribution(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:cloudfront::111111111111:distribution/E1X0H1C4VB45I8',
        )
        base_test.assertEqual(
            resources[0]['DefaultCacheBehavior']['ViewerProtocolPolicy'],
            'allow-all',
        )


class PolicyTest_NoFoundDistributions(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
