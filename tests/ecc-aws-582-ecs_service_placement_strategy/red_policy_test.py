class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['serviceArn'] for r in resources],
            [
                'arn:aws:ecs:us-east-1:644160558196:service/582_ecs_cluster_red/582_ecs_service_red',
                'arn:aws:ecs:us-east-1:644160558196:service/582_ecs_cluster_red/582_ecs_service_red2',
            ],
        )
        for r in resources:
            base_test.assertIn('random', [s['type'] for s in r['placementStrategy']])


class PolicyTest_SpecificService(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['serviceArn'],
            'arn:aws:ecs:us-east-1:644160558196:service/582_ecs_cluster_red/582_ecs_service_red',
        )
        base_test.assertEqual(resources[0]["placementStrategy"][1]["type"], "random")


class PolicyTest_NoFoundServices(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
