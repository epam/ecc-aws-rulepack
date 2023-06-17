class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        client = local_session.client('ec2')
        attributes = client.describe_instance_attribute(
            Attribute='disableApiTermination', InstanceId=resources[0]['InstanceId'])
        base_test.assertFalse(attributes['DisableApiTermination']['Value'])
