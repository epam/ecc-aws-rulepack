class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]["c7n:MatchedListeners"][0]["Protocol"],"HTTP")
        base_test.assertEqual(resources[0]["c7n:MatchedListeners"][0]["DefaultActions"][0]["Type"],"redirect")
        base_test.assertNotEqual(resources[0]["c7n:MatchedListeners"][0]["DefaultActions"][0]["RedirectConfig"]["Protocol"],"HTTPS")
        