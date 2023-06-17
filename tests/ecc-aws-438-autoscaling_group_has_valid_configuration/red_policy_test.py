class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertTupleEqual(resources[0]['Invalid'][0], ('invalid-key-pair', "438_key_pair_red"))
        
        ec2_client = local_session.client("ec2")
        key_pairs = ec2_client.describe_key_pairs()
        for key_pair in key_pairs['KeyPairs']:
            base_test.assertNotEqual(key_pair['KeyName'],"438_key_pair_red")