class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        zone = local_session.client("route53")
        list_logging = zone.list_query_logging_configs()
        base_test.assertFalse(list_logging["QueryLoggingConfigs"])