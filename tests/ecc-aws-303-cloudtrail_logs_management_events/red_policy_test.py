class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        Name = resources[0]['Name']
        cloudtrail_client = local_session.client("cloudtrail")
        IncludeManagementEvents = cloudtrail_client.get_event_selectors(TrailName=Name)['EventSelectors'][0]['IncludeManagementEvents']
        base_test.assertFalse(IncludeManagementEvents)

