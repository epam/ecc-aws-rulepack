class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        iam = local_session.client("iam")
        base_test.assertEqual(iam.list_attached_role_policies(RoleName = "058_role_red")["AttachedPolicies"],[])
