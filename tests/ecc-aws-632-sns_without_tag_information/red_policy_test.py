class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        sns_arn = resources[0]['TopicArn']
        client = local_session.client("sns").list_tags_for_resource(ResourceArn=sns_arn)
        base_test.assertFalse(client['Tags'])