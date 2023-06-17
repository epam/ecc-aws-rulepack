from re import search
from datetime import datetime, timedelta

class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['State']['Name'], 'stopped')
        stoped_date_str=search('\((.*)\)',resources[0]['StateTransitionReason'])
        format = "%Y-%m-%d %H:%M:%S %Z"
        stoped_date_object=datetime.strptime(str(stoped_date_str.group(1)),format)
        time_now= datetime.strptime("2021-10-27 09:31:31","%Y-%m-%d %H:%M:%S")
        datatime30ago=time_now - timedelta(days=30)
        base_test.assertFalse(stoped_date_object>datatime30ago)