class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotIn('InstanceId', local_session.client("ssm").describe_instance_information())
        base_test.assertIn(resources[0]['State']['Name'], ['stopped', 'running'])