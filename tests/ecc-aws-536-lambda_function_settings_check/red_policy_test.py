class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotIn(resources[0]['Runtime'], ['nodejs20.x', 'nodejs18.x', 'python3.12', 'python3.11', 'python3.10', 'python3.9', 'java21', 'java17', 'java11', 'java8.al2', 'dotnet8', 'dotnet6', 'ruby3.3', 'ruby3.2', 'provided.al2023', 'provided.al2'])
