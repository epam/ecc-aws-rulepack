class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:cloudfront::111111111111:distribution/EE2CXH8V6W4CF',
                'arn:aws:cloudfront::111111111111:distribution/EE2CXH8V6W4CG',
            ],
        )
        for r in resources:
            base_test.assertNotEqual(r['Origins']['Items'][0], 'CustomOriginConfig')
            base_test.assertEqual(r['Origins']['Items'][0]['OriginAccessControlId'], '')


class PolicyTest_SpecificDistribution(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:cloudfront::111111111111:distribution/EE2CXH8V6W4CF',
        )
        base_test.assertNotEqual(resources[0]['Origins']['Items'][0], 'CustomOriginConfig')
        base_test.assertEqual(resources[0]['Origins']['Items'][0]['OriginAccessControlId'], '')


class PolicyTest_NoFoundDistributions(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
