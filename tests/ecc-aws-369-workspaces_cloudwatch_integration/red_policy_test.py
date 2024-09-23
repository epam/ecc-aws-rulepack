import json
class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        rules = local_session.client("events").list_rules()
        pattern=json.loads(rules['Rules'][0]['EventPattern'])
        base_test.assertNotEqual(pattern["detail-type"], "WorkSpaces Access")
        base_test.assertNotEqual(pattern["source"], "aws.workspaces")
        workspaces=local_session.client("workspaces").describe_workspaces().get("Workspaces",[])
        base_test.assertNotEqual(len(workspaces), 0)
        
