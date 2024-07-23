       
class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
         base_test.assertEqual(len(resources), 1)
         cloudtrail = local_session.client("cloudtrail").get_event_selectors(TrailName="143_cloudtrail_red")
         base_test.assertNotEqual(cloudtrail['EventSelectors'][0]['ReadWriteType'], 'WriteOnly')  
         base_test.assertNotIn('Type' ,cloudtrail['EventSelectors'][0]['DataResources'])      