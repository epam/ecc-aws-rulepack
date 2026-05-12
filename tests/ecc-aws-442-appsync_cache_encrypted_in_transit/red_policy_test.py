def _assert_transit_encryption_disabled(base_test, cache):
    base_test.assertFalse(cache['transitEncryptionEnabled'])


class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['arn'] for r in resources],
            [
                'arn:aws:appsync:us-east-1:1111111111:apis/pg7ahgkbhrcbnij3z4n7ytzkhu',
                'arn:aws:appsync:us-east-1:1111111111:apis/qh8bhgkbhrcbnij3z4n7ytzkiv',
            ],
        )
        appsync = local_session.client('appsync')
        for r in resources:
            cache = appsync.get_api_cache(apiId=r['apiId'])['apiCache']
            _assert_transit_encryption_disabled(base_test, cache)


class PolicyTest_SpecificGraphqlApi(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['arn'],
            'arn:aws:appsync:us-east-1:1111111111:apis/pg7ahgkbhrcbnij3z4n7ytzkhu',
        )
        appsync = local_session.client('appsync')
        cache = appsync.get_api_cache(apiId=resources[0]['apiId'])['apiCache']
        _assert_transit_encryption_disabled(base_test, cache)


class PolicyTest_NoFoundGraphqlApis(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
