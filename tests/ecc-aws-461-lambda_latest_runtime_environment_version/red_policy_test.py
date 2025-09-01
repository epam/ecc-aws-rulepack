class PolicyTest(object):

     def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertNotRegex(resources[0]['Runtime'], '(nodejs22\.x|python3\.13|java21|provided\.al2023|dotnet9|ruby3\.4)')