class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            sorted([r['GroupId'] for r in resources]),
            sorted(['sg-01c1e44a433d03d17', 'sg-01c1e44a433d03d27']),
        )
        for r in resources:
            base_test.assertEqual(r['IpPermissions'][0]['FromPort'], 0)
            base_test.assertEqual(r['IpPermissions'][0]['ToPort'], 65535)


class PolicyTest_SpecificGroup(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['GroupId'], 'sg-01c1e44a433d03d17')
        base_test.assertEqual(resources[0]['IpPermissions'][0]['FromPort'], 0)
        base_test.assertEqual(resources[0]['IpPermissions'][0]['ToPort'], 65535)


class PolicyTest_NoFoundGroups(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
