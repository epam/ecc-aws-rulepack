def _assert_s3_origin_bucket_missing(base_test, resource, s3_client):
    base_test.assertNotIn('CustomOriginConfig', resource['Origins']['Items'][0])
    s3_bucket_name = resource['Origins']['Items'][0]['DomainName'].split('.')[0]
    for bucket in s3_client.list_buckets()['Buckets']:
        base_test.assertNotEqual(s3_bucket_name, bucket['Name'])


class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ARN'] for r in resources],
            [
                'arn:aws:cloudfront::111111111111:distribution/E371HG4EXIW30T',
                'arn:aws:cloudfront::111111111111:distribution/E371HG4EXIW31U',
            ],
        )
        s3_client = local_session.client('s3')
        for r in resources:
            _assert_s3_origin_bucket_missing(base_test, r, s3_client)


class PolicyTest_SpecificDistribution(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ARN'],
            'arn:aws:cloudfront::111111111111:distribution/E371HG4EXIW30T',
        )
        _assert_s3_origin_bucket_missing(
            base_test,
            resources[0],
            local_session.client('s3'),
        )


class PolicyTest_NoFoundDistributions(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
