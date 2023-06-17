class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        client = local_session.client('ec2')
        attach = client.describe_network_interfaces().get('Attached', ())
        base_test.assertNotIn('Attached', attach)

        
