def _assert_no_rules(base_test, r):
    base_test.assertFalse(r['Rules'])


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['WebACLArn'] for r in resources],
            [
                'arn:aws:waf-regional:us-east-1:111111111111:webacl/c43ed095-1a78-4a0e-9333-c3bdc5054736',
                'arn:aws:waf-regional:us-east-1:111111111111:webacl/d53ed095-1a78-4a0e-9333-c3bdc5054737',
            ],
        )
        for r in resources:
            _assert_no_rules(base_test, r)


class PolicyTest_SpecificWebACL(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['WebACLArn'],
            'arn:aws:waf-regional:us-east-1:111111111111:webacl/c43ed095-1a78-4a0e-9333-c3bdc5054736',
        )
        _assert_no_rules(base_test, resources[0])


class PolicyTest_NoFoundWebACLs(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
