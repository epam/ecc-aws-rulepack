class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['deploymentGroupName'] for r in resources],
            [
                '484_codedeploy_deployment_group_red1',
                '484_codedeploy_deployment_group_red2',
            ],
        )
        for r in resources:
            base_test.assertTrue(r["autoRollbackConfiguration"]["enabled"])
            base_test.assertFalse(r["alarmConfiguration"]["enabled"])


class PolicyTest_SpecificGroup(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['deploymentGroupName'], '484_codedeploy_deployment_group_red1')
        base_test.assertTrue(resources[0]["autoRollbackConfiguration"]["enabled"])
        base_test.assertFalse(resources[0]["alarmConfiguration"]["enabled"])


class PolicyTest_NoFoundGroups(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
