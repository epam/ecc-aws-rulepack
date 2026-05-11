class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['clusterArn'] for r in resources],
            [
                'arn:aws:ecs:us-east-1:111111111111:cluster/464_ecs_cluster_red',
                'arn:aws:ecs:us-east-1:111111111111:cluster/464_ecs_cluster_red2',
            ],
        )
        for r in resources:
            base_test.assertNotIn('configuration', r)


class PolicyTest_SpecificCluster(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['clusterArn'],
            'arn:aws:ecs:us-east-1:111111111111:cluster/464_ecs_cluster_red',
        )
        base_test.assertNotIn('configuration', resources[0])


class PolicyTest_NoFoundClusters(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
