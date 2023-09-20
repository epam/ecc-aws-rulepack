import datetime
from dateutil import tz as tzutil

class PolicyTest(object):

    def mock_time(self):
        return 2023, 9, 20

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]["DBInstanceStatus"], "stopped")
        restart_time = resources[0]["AutomaticRestartTime"]
        time_now = datetime.datetime.fromisoformat(datetime.datetime.utcnow().replace(tzinfo=datetime.timezone.utc).isoformat())
        delta = restart_time - time_now
        base_test.assertTrue(delta.days<=4)
