class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:cloudfront::666666666666:distribution/EEEEEEEEEEEEEEE',
                'arn:aws:cloudfront::666666666666:distribution/GGGGGGGGGGGGGGG',
            ],
        )
        for r in resources:
            base_test.assertNotRegex(
                r['ViewerCertificate']['MinimumProtocolVersion'],
                r'TLSv1\.2_*',
            )


class PolicyTest_SpecificDistribution(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:cloudfront::666666666666:distribution/EEEEEEEEEEEEEEE',
        )
        base_test.assertNotRegex(
            resources[0]['ViewerCertificate']['MinimumProtocolVersion'],
            r'TLSv1\.2_*',
        )


class PolicyTest_NoFoundDistributions(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
