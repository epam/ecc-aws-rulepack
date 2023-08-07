class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
         base_test.assertEqual(len(resources), 1)
         client = local_session.client('ec2')
         logs = client.describe_flow_logs().get('FlowLogs', ())
         base_test.assertEqual(len(logs), 0)
