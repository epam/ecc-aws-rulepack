class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['deploymentGroupName'] for r in resources],
            [
                '485_codedeploy_deployment_group_red',
                '485_codedeploy_deployment_group_red2',
            ],
        )
        for r in resources:
            config = local_session.client("codedeploy").get_deployment_config(
                deploymentConfigName=r['deploymentConfigName']
            )
            base_test.assertLess(config['deploymentConfigInfo']['minimumHealthyHosts']['value'], 66)


class PolicyTest_SpecificGroup(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['deploymentGroupName'], '485_codedeploy_deployment_group_red')
        config = local_session.client("codedeploy").get_deployment_config(
            deploymentConfigName=resources[0]['deploymentConfigName']
        )
        base_test.assertLess(config['deploymentConfigInfo']['minimumHealthyHosts']['value'], 66)


class PolicyTest_NoFoundGroups(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
