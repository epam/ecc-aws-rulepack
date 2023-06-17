from datetime import datetime

class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)

        ExparationDate=datetime.fromisoformat(str(resources[0]['Expiry']))
        ExparationDate = datetime.strptime(str(ExparationDate)[:-6], "%Y-%m-%d %H:%M:%S.%f")
        time_now = datetime.now()
        base_test.assertTrue(ExparationDate<time_now)
