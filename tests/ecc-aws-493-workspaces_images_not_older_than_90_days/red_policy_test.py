from datetime import datetime, timedelta

class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)

        LastAccessedDate=datetime.fromisoformat(str(resources[0]['Created']))
        time_now=datetime.fromisoformat('2022-05-06T02:00:00+00:00')
        datatime90ago=time_now-timedelta(days=90)
        base_test.assertFalse(LastAccessedDate>datatime90ago)
