class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:cloudfront::644160558196:distribution/E3153VPXBPXF29',
                'arn:aws:cloudfront::644160558196:distribution/E3153VPXBPXF30',
            ],
        )
        for r in resources:
            base_test.assertEqual(
                r['Origins']['Items'][0]['CustomOriginConfig']['OriginSslProtocols']['Items'][0],
                'SSLv3',
            )


class PolicyTest_SpecificDistribution(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:cloudfront::644160558196:distribution/E3153VPXBPXF29',
        )
        base_test.assertEqual(
            resources[0]['Origins']['Items'][0]['CustomOriginConfig']['OriginSslProtocols']['Items'][0],
            'SSLv3',
        )


class PolicyTest_NoFoundDistributions(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
