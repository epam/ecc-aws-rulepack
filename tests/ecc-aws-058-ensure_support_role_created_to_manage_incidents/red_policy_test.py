class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        iam = local_session.client("iam").list_attached_role_policies(RoleName = "058_role_red")
        base_test.assertNotIn("arn:aws:iam::aws:policy/AWSSupportAccess" ,iam["AttachedPolicies"][0]["PolicyArn"])