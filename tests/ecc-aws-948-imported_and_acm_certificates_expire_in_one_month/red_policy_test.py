from datetime import datetime, timedelta, date

class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)

        ExparationDate=datetime.fromisoformat(str(resources[0]['NotAfter']))
        ExparationDate = datetime.strptime(str(ExparationDate)[:-6], "%Y-%m-%d %H:%M:%S")
        time_now = datetime.now()
        time_now=datetime.strptime(str(time_now)[:19], "%Y-%m-%d %H:%M:%S")
        datatimein30=time_now+timedelta(days=30)
        base_test.assertTrue(ExparationDate<datatimein30)
