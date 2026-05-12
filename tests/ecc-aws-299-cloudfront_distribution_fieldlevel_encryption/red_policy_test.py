class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:cloudfront::111111111111:distribution/EZLILM9DPTHL3',
                'arn:aws:cloudfront::111111111111:distribution/EZLILM9DPTHL4',
            ],
        )
        for r in resources:
            base_test.assertEqual(r['DefaultCacheBehavior']['FieldLevelEncryptionId'], '')


class PolicyTest_SpecificDistribution(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:cloudfront::111111111111:distribution/EZLILM9DPTHL3',
        )
        base_test.assertEqual(resources[0]['DefaultCacheBehavior']['FieldLevelEncryptionId'], '')


class PolicyTest_NoFoundDistributions(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
