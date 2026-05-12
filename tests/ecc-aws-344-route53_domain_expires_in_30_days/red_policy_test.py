from datetime import datetime, timedelta


def _assert_expires_within_30_days(base_test, r):
    expiry = datetime.fromisoformat(str(r['Expiry']))
    time_now = datetime.fromisoformat('2023-02-01 00:05:23.283+00:00')
    base_test.assertTrue(expiry > time_now)
    datetime_in_30 = time_now + timedelta(days=30)
    base_test.assertTrue(expiry < datetime_in_30)


class PolicyTest(object):

    def mock_time(self):
        return 2023, 2, 1

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
            _assert_expires_within_30_days(base_test, r)


class PolicyTest_SpecificDomain(object):

    def mock_time(self):
        return 2023, 2, 1

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['DomainName'], 'custodian-rule.click')
        _assert_expires_within_30_days(base_test, resources[0])


class PolicyTest_NoFoundDomains(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
