class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        fsx_client = local_session.client("fsx")
        volume_id = resources[0]['OpenZFSConfiguration']['RootVolumeId']
        fsx = fsx_client.describe_volumes(VolumeIds=[volume_id])
        base_test.assertFalse(fsx['Volumes'][0]['OpenZFSConfiguration']['CopyTagsToSnapshots'])

