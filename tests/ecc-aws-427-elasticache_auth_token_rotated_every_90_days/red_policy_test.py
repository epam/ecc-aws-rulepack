from datetime import datetime, timedelta

class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        if 'AuthTokenLastModifiedDate' in resources[0]:
            LastModifiedDate=datetime.fromisoformat(str(resources[0]['AuthTokenLastModifiedDate']))
            time_now=datetime.fromisoformat('2022-01-19T02:00:00+00:00')
            datatime90ago=time_now-timedelta(days=90)
            base_test.assertFalse(LastModifiedDate>datatime90ago)