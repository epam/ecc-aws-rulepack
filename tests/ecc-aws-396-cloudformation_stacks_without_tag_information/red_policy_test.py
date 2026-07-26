class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['StackId'] for r in resources],
            [
                'arn:aws:cloudformation:us-east-1:111111111111:stack/stack-396-red/84c55dc0-7c6d-11ed-b49d-0efc57186963',
                'arn:aws:cloudformation:us-east-1:111111111111:stack/stack-396-red2/22222222-7c6d-11ed-b49d-0efc57186963',
            ],
        )
        for r in resources:
            base_test.assertFalse(r['Tags'])


class PolicyTest_SpecificStack(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['StackId'],
            'arn:aws:cloudformation:us-east-1:111111111111:stack/stack-396-red/84c55dc0-7c6d-11ed-b49d-0efc57186963',
        )
        base_test.assertFalse(resources[0]['Tags'])


class PolicyTest_NoFoundStacks(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
