from datetime import datetime, timedelta


def _assert_certificate_expires_within_30_days(base_test, cert):
    expiration_date = datetime.fromisoformat(str(cert['NotAfter']))
    expiration_date = datetime.strptime(str(expiration_date)[:-6], "%Y-%m-%d %H:%M:%S")
    time_now = datetime.now()
    time_now = datetime.strptime(str(time_now)[:19], "%Y-%m-%d %H:%M:%S")
    datetime_in_30 = time_now + timedelta(days=30)
    base_test.assertTrue(expiration_date < datetime_in_30)


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['CertificateArn'] for r in resources],
            [
                'arn:aws:acm:us-east-1:111111111111:certificate/9ce9c801-b6bc-4e26-b77a-914a893b241c',
                'arn:aws:acm:us-east-1:111111111111:certificate/0a1ff233-bfcb-488e-ba7c-222222222222',
            ],
        )
        for r in resources:
            _assert_certificate_expires_within_30_days(base_test, r)


class PolicyTest_SpecificCertificate(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['CertificateArn'],
            'arn:aws:acm:us-east-1:111111111111:certificate/9ce9c801-b6bc-4e26-b77a-914a893b241c',
        )
        _assert_certificate_expires_within_30_days(base_test, resources[0])


class PolicyTest_NoFoundCertificates(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
