class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        kms = local_session.client("kms").list_aliases()["Aliases"][0]
        base_test.assertEqual(kms['AliasName'], 'alias/aws/sns')