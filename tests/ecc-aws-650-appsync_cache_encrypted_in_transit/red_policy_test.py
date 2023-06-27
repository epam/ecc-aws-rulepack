class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        appsync = local_session.client("appsync").get_api_cache(apiId=resources[0]["apiId"])
        base_test.assertFalse(appsync['apiCache']['transitEncryptionEnabled'])