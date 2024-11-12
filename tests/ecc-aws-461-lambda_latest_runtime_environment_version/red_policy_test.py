class PolicyTest(object):

     def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotRegex(resources[0]['Runtime'], '(nodejs20\.x|python3\.12|java21|provided\.al2023|dotnet8|ruby3\.3)')