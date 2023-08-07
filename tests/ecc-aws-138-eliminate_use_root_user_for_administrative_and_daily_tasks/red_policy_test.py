import datetime

class PolicyTest(object):

    def mock_time(self):
        return 2023, 6, 21

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)

        passwordLastUsed=datetime.datetime.fromisoformat(str(resources[0]['c7n:credential-report']['password_last_used']))
        time_now = datetime.datetime.fromisoformat(datetime.datetime.utcnow().replace(microsecond=0).replace(tzinfo=datetime.timezone.utc).isoformat())
        delta = time_now - passwordLastUsed
        base_test.assertTrue(delta.days<90)