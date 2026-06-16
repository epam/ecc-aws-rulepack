class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['GroupId'] for r in resources],
            ['sg-1234567asdfg', 'sg-2234567asdfg'],
        )
        for r in resources:
            base_test.assertNotIn('Tags', r)


class PolicyTest_SpecificGroup(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['GroupId'], 'sg-1234567asdfg')
        base_test.assertNotIn('Tags', resources[0])


class PolicyTest_NoFoundGroups(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
