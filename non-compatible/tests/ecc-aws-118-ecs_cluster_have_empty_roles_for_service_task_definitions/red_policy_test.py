class PolicyTest(object):

     def test_resources_with_client(self, base_test, resources, local_session):
         base_test.assertEqual(len(resources), 1)
         split = resources[0]['taskDefinition'].split('/',1)
         taskName = split[1]
         taskDef = local_session.client("ecs").describe_task_definition(taskDefinition=taskName)
         base_test.assertNotIn('taskRoleArn', taskDef['taskDefinition'])