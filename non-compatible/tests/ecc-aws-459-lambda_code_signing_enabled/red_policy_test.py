class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        lambda_func = resources[0]['FunctionName']
        client = local_session.client("lambda").get_function_code_signing_config(FunctionName=lambda_func)
        base_test.assertFalse(client['ResponseMetadata'])