def _assert_no_tags(base_test, r):
    base_test.assertFalse(r['Tags'])


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['RouteTableId'] for r in resources],
            [
                'rtb-0f28fb304278d004a',
                'rtb-0f28fb304278d004b',
            ],
        )
        for r in resources:
            _assert_no_tags(base_test, r)


class PolicyTest_SpecificRouteTable(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['RouteTableId'], 'rtb-0f28fb304278d004a')
        _assert_no_tags(base_test, resources[0])


class PolicyTest_NoFoundRouteTables(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
