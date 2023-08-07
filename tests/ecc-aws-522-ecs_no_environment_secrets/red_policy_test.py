class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        for resource in resources[0]['containerDefinitions'][0]['environment']:
            if resource['name'] == '^(?!arn).*':
                base_test.assertNotRegex(resource['value'], r'^(?!arn).*')