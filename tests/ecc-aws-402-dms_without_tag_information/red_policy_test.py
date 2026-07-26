class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['ReplicationInstanceArn'] for r in resources],
            [
                'arn:aws:dms:us-east-1:111111111111:rep:5SOAP4UN5HQORSQZZINL6J7OSCHEKHL7XWACL7Y',
                'arn:aws:dms:us-east-1:111111111111:rep:22222222222222222222222222222222222222',
            ],
        )
        for r in resources:
            base_test.assertFalse(r['Tags'])
            tag = local_session.client("dms").list_tags_for_resource(
                ResourceArn=r['ReplicationInstanceArn']
            )
            base_test.assertFalse(tag['TagList'])


class PolicyTest_SpecificInstance(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['ReplicationInstanceArn'],
            'arn:aws:dms:us-east-1:111111111111:rep:5SOAP4UN5HQORSQZZINL6J7OSCHEKHL7XWACL7Y',
        )
        base_test.assertFalse(resources[0]['Tags'])


class PolicyTest_NoFoundInstances(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
