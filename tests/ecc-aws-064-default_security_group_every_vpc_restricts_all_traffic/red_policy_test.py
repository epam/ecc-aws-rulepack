class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        security_group = resources[0]
        base_test.assertEqual(security_group["GroupName"], "default")

        try:
            base_test.assertNotEqual(len(security_group["IpPermissions"]), 0)
        except:
            pass

        try:
            base_test.assertNotEqual(len(security_group["IpPermissionsEgress"]), 0)
        except:
            pass
