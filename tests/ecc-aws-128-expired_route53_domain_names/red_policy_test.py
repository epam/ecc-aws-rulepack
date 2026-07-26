from datetime import datetime


def _assert_expired(base_test, r):
    val = r['Expiry']
    if isinstance(val, datetime):
        expiry = val
    else:
        expiry = datetime.fromisoformat(str(val).replace('Z', '+00:00'))
    now = datetime.now(tz=expiry.tzinfo) if expiry.tzinfo else datetime.now()
    base_test.assertTrue(expiry < now)


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
            _assert_expired(base_test, r)


class PolicyTest_SpecificDomain(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['DomainName'], 'custodian-rule.click')
        _assert_expired(base_test, resources[0])


class PolicyTest_NoFoundDomains(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
