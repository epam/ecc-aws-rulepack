from datetime import datetime, timedelta

class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        LastAccessedDate=datetime.fromisoformat(str(resources[0]['StartTime']))
        time_now= datetime.fromisoformat('2023-07-21 13:27:14.283+00:00')
        datatime30ago=time_now-timedelta(days=30)
        base_test.assertFalse(LastAccessedDate>datatime30ago)