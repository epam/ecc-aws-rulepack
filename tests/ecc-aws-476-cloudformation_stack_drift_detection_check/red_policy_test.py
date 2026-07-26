class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['StackId'] for r in resources],
            [
                'arn:aws:cloudformation:us-east-1:111111111111:stack/stack-476-red/8b4a36c0-06d9-11ed-9110-12bd5528e831',
                'arn:aws:cloudformation:us-east-1:111111111111:stack/stack-476-red2/22222222-06d9-11ed-9110-12bd5528e831',
            ],
        )
        for r in resources:
            base_test.assertEqual(r["StackStatus"], "CREATE_COMPLETE")
            base_test.assertEqual(r["DriftInformation"]["StackDriftStatus"], "DRIFTED")


class PolicyTest_SpecificStack(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['StackId'],
            'arn:aws:cloudformation:us-east-1:111111111111:stack/stack-476-red/8b4a36c0-06d9-11ed-9110-12bd5528e831',
        )
        base_test.assertEqual(resources[0]["StackStatus"], "CREATE_COMPLETE")
        base_test.assertEqual(resources[0]["DriftInformation"]["StackDriftStatus"], "DRIFTED")


class PolicyTest_NoFoundStacks(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
