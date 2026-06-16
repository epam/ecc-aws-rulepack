class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:es:us-east-1:this:domain/domain-153-red',
                'arn:aws:es:us-east-1:this:domain/domain-153-red-b',
            ],
        )
        for r in resources:
            base_test.assertFalse('LogPublishingOptions' in r)


class PolicyTest_SpecificDomain(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:es:us-east-1:this:domain/domain-153-red',
        )
        base_test.assertFalse('LogPublishingOptions' in resources[0])


class PolicyTest_NoFoundDomains(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
