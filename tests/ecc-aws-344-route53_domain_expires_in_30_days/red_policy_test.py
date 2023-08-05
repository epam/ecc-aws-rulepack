from datetime import datetime, timedelta

class PolicyTest(object):

    def mock_time(self):
        return 2023, 2, 1

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)

        ExparationDate=datetime.fromisoformat(str(resources[0]['Expiry']))
        time_now = datetime.fromisoformat('2023-02-01 00:05:23.283+00:00')
        base_test.assertTrue(ExparationDate>time_now)
        datatimein30=time_now+timedelta(days=30)
        base_test.assertTrue(ExparationDate<datatimein30)
