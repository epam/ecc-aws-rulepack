from datetime import datetime, timedelta


def _assert_unused_secret(base_test, r):
    if 'LastAccessedDate' in r:
        last_accessed = datetime.fromisoformat(str(r['LastAccessedDate']))
        time_now = datetime.fromisoformat('2021-11-03T02:00:00+00:00')
        datetime_90_ago = time_now - timedelta(days=90)
        base_test.assertFalse(last_accessed > datetime_90_ago)
    else:
        base_test.assertNotIn('LastAccessedDate', r)


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:secretsmanager:us-east-1:644160558196:secret:220_secret_red-dISQOQ',
                'arn:aws:secretsmanager:us-east-1:644160558196:secret:220_secret_red_b-eJSRPR',
            ],
        )
        for r in resources:
            _assert_unused_secret(base_test, r)


class PolicyTest_SpecificSecret(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:secretsmanager:us-east-1:644160558196:secret:220_secret_red-dISQOQ',
        )
        _assert_unused_secret(base_test, resources[0])


class PolicyTest_NoFoundSecrets(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
