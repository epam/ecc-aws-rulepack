
class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['Id'] for r in resources],
            [
                '/hostedzone/Z02315613BNTIIDGXHMO5',
                '/hostedzone/Z349SECONDZONE0001',
            ],
        )
        zone = local_session.client('route53')
        list_logging = zone.list_query_logging_configs()
        base_test.assertFalse(list_logging['QueryLoggingConfigs'])


class PolicyTest_SpecificHostedZone(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['Id'],
            '/hostedzone/Z02315613BNTIIDGXHMO5',
        )
        zone = local_session.client('route53')
        list_logging = zone.list_query_logging_configs()
        base_test.assertFalse(list_logging['QueryLoggingConfigs'])


class PolicyTest_NoFoundHostedZones(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
