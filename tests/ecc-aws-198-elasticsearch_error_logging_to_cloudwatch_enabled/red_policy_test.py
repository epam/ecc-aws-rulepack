def _assert_app_logs_disabled(base_test, r):
    base_test.assertFalse(
        r['LogPublishingOptions']['ES_APPLICATION_LOGS']['Enabled'],
    )


class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:es:us-east-1:this:domain/domain-198-red',
                'arn:aws:es:us-east-1:this:domain/domain-198-red-b',
            ],
        )
        for r in resources:
            _assert_app_logs_disabled(base_test, r)


class PolicyTest_SpecificDomain(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:es:us-east-1:this:domain/domain-198-red',
        )
        _assert_app_logs_disabled(base_test, resources[0])


class PolicyTest_NoFoundDomains(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
