class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        
        trail_client = local_session.client("cloudtrail")
        trail_name = "cloudtrail-358-red2"
        describe_trails = trail_client.describe_trails(trailNameList=[trail_name])
        base_test.assertFalse(describe_trails["trailList"][0]["IsMultiRegionTrail"])
        base_test.assertFalse(describe_trails["trailList"][0]["IncludeGlobalServiceEvents"])
        base_test.assertTrue(describe_trails["trailList"][0]["LogFileValidationEnabled"])
        base_test.assertNotIn('KmsKeyId', describe_trails["trailList"][0])
        
        trail_status = trail_client.get_trail_status(Name=trail_name)
        base_test.assertTrue(trail_status["IsLogging"])
        
        event_selectors = trail_client.get_event_selectors(TrailName=trail_name)
        ReadWriteType = IncludeManagementEvents = ExcludeManagementEventSources = False
        green_selector = False
        for selector in event_selectors.get("EventSelectors"):
            if selector.get("ReadWriteType") == "All":
                ReadWriteType = True
            if selector.get("IncludeManagementEvents") is True:
                IncludeManagementEvents = True
            if not selector.get("ExcludeManagementEventSources"):
                ExcludeManagementEventSources = True
        if ReadWriteType and IncludeManagementEvents and ExcludeManagementEventSources:
            green_selector = True
        base_test.assertFalse(green_selector)