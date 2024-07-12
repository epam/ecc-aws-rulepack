       
class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        cloudtrail_ev_sel = local_session.client("cloudtrail").get_event_selectors(TrailName="cloudtrail-358-red1")
        
        if cloudtrail_ev_sel['AdvancedEventSelectors'][0]['FieldSelectors'][0]['Field'] == 'eventCategory':
            base_test.assertEqual(cloudtrail_ev_sel['AdvancedEventSelectors'][0]['FieldSelectors'][0]['Equals'][0], 'Management')  
        elif cloudtrail_ev_sel['AdvancedEventSelectors'][0]['FieldSelectors'][0]['Field'] == 'eventSource':
            base_test.assertEqual(cloudtrail_ev_sel['AdvancedEventSelectors'][0]['FieldSelectors'][0]['NotEquals'][0], 'rdsdata.amazonaws.com')  
        
        cloudtrail_status = local_session.client("cloudtrail").get_trail_status(Name="cloudtrail-358-red1")['IsLogging']
        base_test.assertTrue(cloudtrail_status)
    	
        cloudtrail = local_session.client("cloudtrail").get_trail(Name="cloudtrail-358-red1")
        base_test.assertTrue(cloudtrail['Trail']['IncludeGlobalServiceEvents'])
        base_test.assertTrue(cloudtrail['Trail']['IsMultiRegionTrail'])
        base_test.assertNotIn('KmsKeyId',cloudtrail['Trail'])
    	
    	
    	
    	
    	