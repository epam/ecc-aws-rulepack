def _assert_public_policy(base_test, r):
    base_test.assertRegex(r['Policy'], '.*\\\"Principal\\\":\\\"[*]\\\".*')


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['Arn'] for r in resources],
            [
                'arn:aws:events:us-east-1:111111111111:event-bus/304_event_bus_red',
                'arn:aws:events:us-east-1:111111111111:event-bus/304_event_bus_red_b',
            ],
        )
        for r in resources:
            _assert_public_policy(base_test, r)


class PolicyTest_SpecificEventBus(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['Arn'],
            'arn:aws:events:us-east-1:111111111111:event-bus/304_event_bus_red',
        )
        _assert_public_policy(base_test, resources[0])


class PolicyTest_NoFoundEventBuses(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
