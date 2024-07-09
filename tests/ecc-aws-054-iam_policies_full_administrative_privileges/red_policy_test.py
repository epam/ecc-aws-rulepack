class PolicyTest(object):
    
    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(resources[0]['PolicyName'], "054_policy_red")
        base_test.assertGreaterEqual(resources[0]['AttachmentCount'], 1)
        
        client = local_session.client("iam") 
        DefaultVersionId = resources[0]['DefaultVersionId']
        Arn = resources[0]["Arn"]
        
        policy = client.get_policy_version( PolicyArn=Arn,  VersionId = DefaultVersionId)
        base_test.assertEqual(policy['PolicyVersion']['Document']['Statement'][0]['Action'],'*')
        base_test.assertEqual(policy['PolicyVersion']['Document']['Statement'][0]['Resource'],'*')
        base_test.assertEqual(policy['PolicyVersion']['Document']['Statement'][0]['Effect'],'Allow')