class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            sorted([r['GroupId'] for r in resources]),
            sorted(['sg-123456789abcdef12', 'sg-223456789abcdef12']),
        )
        for r in resources:
            base_test.assertEqual(r["GroupName"], "default")
            try:
                base_test.assertNotEqual(len(r["IpPermissions"]), 0)
            except Exception:
                pass
            try:
                base_test.assertNotEqual(len(r["IpPermissionsEgress"]), 0)
            except Exception:
                pass


class PolicyTest_SpecificGroup(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['GroupId'], 'sg-123456789abcdef12')
        base_test.assertEqual(resources[0]["GroupName"], "default")

        try:
            base_test.assertNotEqual(len(resources[0]["IpPermissions"]), 0)
        except Exception:
            pass
        try:
            base_test.assertNotEqual(len(resources[0]["IpPermissionsEgress"]), 0)
        except Exception:
            pass


class PolicyTest_NoFoundGroups(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
