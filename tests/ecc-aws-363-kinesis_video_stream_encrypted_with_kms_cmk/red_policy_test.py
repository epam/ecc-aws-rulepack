class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        alias = resources[0]['KmsKeyId'].split(":")[-1]
        base_test.assertEqual(alias, 'alias/aws/kinesisvideo')