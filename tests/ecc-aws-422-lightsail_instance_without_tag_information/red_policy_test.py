def _assert_no_tags(base_test, r):
    base_test.assertFalse(r['tags'])


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['arn'] for r in resources],
            [
                'arn:aws:lightsail:us-east-1:111111111111:Instance/eb4b75c9-3568-439e-89ef-383f410e4aec',
                'arn:aws:lightsail:us-east-1:111111111111:Instance/fc5c86da-4679-54af-90ef-494a521f5bfd',
            ],
        )
        for r in resources:
            _assert_no_tags(base_test, r)


class PolicyTest_SpecificInstance(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['arn'],
            'arn:aws:lightsail:us-east-1:111111111111:Instance/eb4b75c9-3568-439e-89ef-383f410e4aec',
        )
        _assert_no_tags(base_test, resources[0])


class PolicyTest_NoFoundInstances(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
