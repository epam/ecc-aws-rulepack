class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        
        trail_client = local_session.client("cloudtrail")
        trail_name = "143_cloudtrail_red1"
        describe_trails = trail_client.describe_trails(trailNameList=[trail_name])
        base_test.assertTrue(describe_trails["trailList"][0]["IsMultiRegionTrail"])
        
        trail_status = trail_client.get_trail_status(Name=trail_name)
        base_test.assertTrue(trail_status["IsLogging"])
        
        event_selectors = trail_client.get_event_selectors(TrailName=trail_name)
        res_type = event_category = res_arn = event_name = readonly = readonly_present = False
        green_selector = False
        for adv_selector in event_selectors.get("AdvancedEventSelectors"):
            field_selectors=adv_selector.get("FieldSelectors")
            for field_selector in field_selectors:
                if field_selector.get("Field")=="eventCategory" and field_selector.get("Equals")==["Data"]:
                    event_category = True
                elif field_selector.get("Field")=="resources.type" and field_selector.get("Equals")==["AWS::S3::Object"]:
                    res_type = True
                elif field_selector.get("Field")=="resources.ARN":
                    res_arn = True
                elif field_selector.get("Field")=="eventName":
                    event_name = True
                elif field_selector.get("Field")=="readOnly" and field_selector.get("Equals")==["true"]:
                    readonly = True
                elif field_selector.get("Field") == "readOnly":
                    readonly_present = True
            if event_category and res_type and not res_arn and not event_name and (not readonly_present or readonly):
                green_selector = True
                break
        base_test.assertFalse(green_selector)