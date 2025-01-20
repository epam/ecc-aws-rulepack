class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        
        trail_client = local_session.client("cloudtrail")
        trail_name = "cloudtrail-052-red-1"
        describe_trails = trail_client.describe_trails(trailNameList=[trail_name])
        base_test.assertTrue(describe_trails["trailList"][0]["IsMultiRegionTrail"])
        base_test.assertTrue(describe_trails["trailList"][0]["IncludeGlobalServiceEvents"])
        
        trail_status = trail_client.get_trail_status(Name=trail_name)
        base_test.assertTrue(trail_status["IsLogging"])
        
        event_selectors = trail_client.get_event_selectors(TrailName=trail_name)
        correct_selector_present = False
        for selector in event_selectors.get("AdvancedEventSelectors"):
            FieldSelectors=selector.get("FieldSelectors")
            if len(FieldSelectors) == 1:
                if FieldSelectors[0].get("Field")=="eventCategory" and FieldSelectors[0].get("Equals")==["Management"]:
                    correct_selector_present = True
                    break
        base_test.assertFalse(correct_selector_present)