_SUPPORTED_RUNTIMES = (
    'nodejs22.x',
    'nodejs20.x',
    'nodejs18.x',
    'python3.13',
    'python3.12',
    'python3.11',
    'python3.10',
    'python3.9',
    'java21',
    'java17',
    'java11',
    'java8.al2',
    'dotnet9',
    'dotnet8',
    'dotnet6',
    'ruby3.4',
    'ruby3.3',
    'ruby3.2',
    'provided.al2023',
    'provided.al2',
)


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['FunctionArn'] for r in resources],
            [
                'arn:aws:lambda:us-east-1:111111111111:function:536_lambda_red',
                'arn:aws:lambda:us-east-1:111111111111:function:536_lambda_red_b',
            ],
        )
        for r in resources:
            base_test.assertNotIn(r['Runtime'], _SUPPORTED_RUNTIMES)


class PolicyTest_SpecificFunction(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['FunctionArn'],
            'arn:aws:lambda:us-east-1:111111111111:function:536_lambda_red',
        )
        base_test.assertNotIn(resources[0]['Runtime'], _SUPPORTED_RUNTIMES)


class PolicyTest_NoFoundFunctions(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
