class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['arn'] for r in resources],
            [
                'arn:aws:codebuild:us-east-1:111111111111:token/bitbucket',
                'arn:aws:codebuild:us-east-1:111111111111:token/github',
            ],
        )
        for r in resources:
            base_test.assertIn(r['serverType'], ['BITBUCKET', 'GITHUB'])
            base_test.assertNotEqual(r['authType'], 'OAUTH')


class PolicyTest_SpecificCredential(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['arn'],
            'arn:aws:codebuild:us-east-1:111111111111:token/bitbucket',
        )
        base_test.assertEqual(resources[0]['serverType'], 'BITBUCKET')
        base_test.assertNotEqual(resources[0]['authType'], 'OAUTH')


class PolicyTest_NoFoundCredentials(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
