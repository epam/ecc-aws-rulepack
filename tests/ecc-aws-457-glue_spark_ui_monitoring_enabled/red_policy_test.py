def _assert_spark_ui_not_enabled(base_test, r):
    base_test.assertNotIn('DefaultArguments', r)


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['Name'] for r in resources],
            [
                '457_glue_job_red',
                '457_glue_job_red_b',
            ],
        )
        for r in resources:
            _assert_spark_ui_not_enabled(base_test, r)


class PolicyTest_SpecificJob(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Name'], '457_glue_job_red')
        _assert_spark_ui_not_enabled(base_test, resources[0])


class PolicyTest_NoFoundJobs(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
