class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['Arn'] for r in resources],
            [
                'arn:aws:airflow:us-east-1:644160558196:environment/mwaa_508_red',
                'arn:aws:airflow:us-east-1:644160558196:environment/mwaa_508_red2',
            ],
        )
        for r in resources:
            base_test.assertNotEqual(r['AirflowVersion'], '2.10.3')


class PolicyTest_SpecificEnvironment(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['Arn'],
            'arn:aws:airflow:us-east-1:644160558196:environment/mwaa_508_red',
        )
        base_test.assertNotEqual(resources[0]['AirflowVersion'], '2.10.3')


class PolicyTest_NoFoundEnvironments(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
