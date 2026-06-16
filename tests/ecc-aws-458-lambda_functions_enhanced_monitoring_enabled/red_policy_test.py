class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['FunctionArn'] for r in resources],
            [
                'arn:aws:lambda:us-east-1:111111111111:function:458_lambda_red',
                'arn:aws:lambda:us-east-1:111111111111:function:458_lambda_red_b',
            ],
        )
        for r in resources:
            base_test.assertNotIn('Layers', r)


class PolicyTest_SpecificFunction(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['FunctionArn'],
            'arn:aws:lambda:us-east-1:111111111111:function:458_lambda_red',
        )
        base_test.assertNotIn('Layers', resources[0])


class PolicyTest_NoFoundFunctions(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
