class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['taskDefinitionArn'] for r in resources],
            [
                'arn:aws:ecs:us-east-1:644160558196:task-definition/118_task_red:4',
                'arn:aws:ecs:us-east-1:644160558196:task-definition/118_task_red2:1',
            ],
        )
        for r in resources:
            base_test.assertNotIn("taskRoleArn", r)


class PolicyTest_SpecificTaskDefinition(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['taskDefinitionArn'],
            'arn:aws:ecs:us-east-1:644160558196:task-definition/118_task_red:4',
        )
        base_test.assertNotIn("taskRoleArn", resources[0])


class PolicyTest_NoFoundTaskDefinitions(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
