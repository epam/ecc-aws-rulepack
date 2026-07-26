class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['clusterArn'] for r in resources],
            [
                'arn:aws:ecs:us-east-1:111111111111:cluster/493_ecs_cluster_red',
                'arn:aws:ecs:us-east-1:111111111111:cluster/493_ecs_cluster_red2',
            ],
        )
        for r in resources:
            base_test.assertEqual(r['settings'][0]['value'], 'disabled')


class PolicyTest_SpecificCluster(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['clusterArn'],
            'arn:aws:ecs:us-east-1:111111111111:cluster/493_ecs_cluster_red',
        )
        base_test.assertEqual(resources[0]['settings'][0]['value'], 'disabled')


class PolicyTest_NoFoundClusters(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
