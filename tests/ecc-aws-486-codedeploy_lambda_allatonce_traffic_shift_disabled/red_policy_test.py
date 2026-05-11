class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['deploymentGroupName'] for r in resources],
            [
                '486_codedeploy_deployment_group_red',
                '486_codedeploy_deployment_group_red2',
            ],
        )
        for r in resources:
            base_test.assertEqual(r["deploymentConfigName"], "CodeDeployDefault.LambdaAllAtOnce")
            base_test.assertEqual(r["computePlatform"], "Lambda")


class PolicyTest_SpecificGroup(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['deploymentGroupName'], '486_codedeploy_deployment_group_red')
        base_test.assertEqual(resources[0]["deploymentConfigName"], "CodeDeployDefault.LambdaAllAtOnce")
        base_test.assertEqual(resources[0]["computePlatform"], "Lambda")


class PolicyTest_NoFoundGroups(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
