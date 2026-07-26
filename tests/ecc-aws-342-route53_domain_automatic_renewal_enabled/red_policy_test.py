def _assert_auto_renew_disabled(base_test, r):
    base_test.assertEqual(r['AutoRenew'], False)


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['DomainName'] for r in resources],
            [
                'custodian-rule.click',
                'custodian-rule-red-b.click',
            ],
        )
        for r in resources:
            _assert_auto_renew_disabled(base_test, r)


class PolicyTest_SpecificDomain(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['DomainName'], 'custodian-rule.click')
        _assert_auto_renew_disabled(base_test, resources[0])


class PolicyTest_NoFoundDomains(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
