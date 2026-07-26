class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['name'] for r in resources],
            ['487-codepipeline-red', '487-codepipeline-red2'],
        )
        for r in resources:
            base_test.assertNotIn('encryptionKey', r['artifactStore'])


class PolicyTest_SpecificPipeline(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['name'], '487-codepipeline-red')
        base_test.assertNotIn('encryptionKey', resources[0]['artifactStore'])


class PolicyTest_NoFoundPipelines(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
