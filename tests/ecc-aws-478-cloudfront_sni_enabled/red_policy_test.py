class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:cloudfront::111111111111:distribution/ENM51XE4M776R',
                'arn:aws:cloudfront::111111111111:distribution/ENM51XE4M777S',
            ],
        )
        for r in resources:
            base_test.assertEqual(r['ViewerCertificate']['SSLSupportMethod'], 'vip')


class PolicyTest_SpecificDistribution(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:cloudfront::111111111111:distribution/ENM51XE4M776R',
        )
        base_test.assertEqual(resources[0]['ViewerCertificate']['SSLSupportMethod'], 'vip')


class PolicyTest_NoFoundDistributions(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
