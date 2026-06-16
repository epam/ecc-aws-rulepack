def _assert_code_signing_response(base_test, local_session, function_name):
    client = local_session.client("lambda").get_function_code_signing_config(
        FunctionName=function_name
    )
    base_test.assertFalse(client['ResponseMetadata'])


class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['FunctionArn'] for r in resources],
            [
                'arn:aws:lambda:us-east-1:644160558196:function:459_lambda_red',
                'arn:aws:lambda:us-east-1:644160558196:function:459_lambda_red_b',
            ],
        )
        for r in resources:
            _assert_code_signing_response(
                base_test, local_session, r['FunctionName']
            )


class PolicyTest_SpecificFunction(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['FunctionArn'],
            'arn:aws:lambda:us-east-1:644160558196:function:459_lambda_red',
        )
        _assert_code_signing_response(
            base_test, local_session, resources[0]['FunctionName']
        )


class PolicyTest_NoFoundFunctions(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
