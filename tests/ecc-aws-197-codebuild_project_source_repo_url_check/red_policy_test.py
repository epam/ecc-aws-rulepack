class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertEqual(resources[0]['source']['auth']['type'] , 'OAUTH')
        base_test.assertEqual(resources[1]['source']['auth']['type'] , 'OAUTH')


        
