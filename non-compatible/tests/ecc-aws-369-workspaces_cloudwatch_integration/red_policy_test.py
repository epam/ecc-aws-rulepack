class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        rules = local_session.client("events").list_rules()
        base_test.assertNotRegexpMatches(rules['Rules'][0]['EventPattern'], "{\\\"detail-type\\\":\[\\\"WorkSpaces Access\\\"\],\\\"source\\\":\[\\\"aws\.workspaces\\\"\]}")