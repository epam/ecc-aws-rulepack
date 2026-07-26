def _assert_autoscaling_not_enabled(base_test, r):
    base_test.assertNotIn('DefaultArguments."--enable-auto-scaling"', r)


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['Name'] for r in resources],
            [
                '542_glue_job_red',
                '542_glue_job_red_b',
            ],
        )
        for r in resources:
            _assert_autoscaling_not_enabled(base_test, r)


class PolicyTest_SpecificJob(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['Name'], '542_glue_job_red')
        _assert_autoscaling_not_enabled(base_test, resources[0])


class PolicyTest_NoFoundJobs(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
