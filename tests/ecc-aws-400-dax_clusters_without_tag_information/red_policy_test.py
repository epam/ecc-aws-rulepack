class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        resource_name = resources[0]['ClusterName']
        dax_client = local_session.client("dax").list_tags(ResourceName=resource_name)
        base_test.assertFalse(dax_client['Tags'])