class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['serviceArn'] for r in resources],
            [
                'arn:aws:ecs:us-east-1:this:service/165_ecs_cluster_red/165_ecs_service_red',
                'arn:aws:ecs:us-east-1:this:service/165_ecs_cluster_red/165_ecs_service_red2',
            ],
        )
        for r in resources:
            base_test.assertEqual(
                r['deployments'][0]['networkConfiguration']['awsvpcConfiguration']['assignPublicIp'],
                'ENABLED',
            )


class PolicyTest_SpecificService(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['serviceArn'],
            'arn:aws:ecs:us-east-1:this:service/165_ecs_cluster_red/165_ecs_service_red',
        )
        base_test.assertEqual(
            resources[0]['deployments'][0]['networkConfiguration']['awsvpcConfiguration']['assignPublicIp'],
            'ENABLED',
        )


class PolicyTest_NoFoundServices(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
