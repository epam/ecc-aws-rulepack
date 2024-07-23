from datetime import datetime, timedelta, timezone

class PolicyTest(object):
        
    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        ec2_client = local_session.client("ec2") 
        VolumeId = resources[0]['VolumeId']
        snapshots = ec2_client.describe_snapshots(Filters=[{'Name':'volume-id','Values':[VolumeId]}])
        if snapshots.get('Snapshots'):
                snapshot=snapshots.get('Snapshots')
                datetimeSnapshot=datetime.fromisoformat(str(snapshot[0].get('StartTime')))
                time_now= datetime.fromisoformat('2024-07-09 00:12:19.000+00:00')
                datatime14ago=time_now-timedelta(days=14)
                base_test.assertFalse(datetimeSnapshot>datatime14ago)
        else:
                base_test.assertEqual(snapshots.get('Snapshots'), [])
