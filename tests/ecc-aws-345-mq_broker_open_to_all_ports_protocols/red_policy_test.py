def _assert_mq_security_group_ports(base_test, r, local_session):
    ec2_client = local_session.client("ec2")
    security_groups = ec2_client.describe_security_groups(
        GroupIds=r["SecurityGroups"][0].split()
    )
    base_test.assertNotEqual(
        security_groups["SecurityGroups"][0]["IpPermissions"][0]["FromPort"],
        "8162",
    )
    base_test.assertNotEqual(
        security_groups["SecurityGroups"][0]["IpPermissions"][0]["ToPort"],
        "8162",
    )


class PolicyTest(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['BrokerArn'] for r in resources],
            [
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-345-red:b-f231d914-c165-43f0-ab6b-1fe5755f6627',
                'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-345-red-b-b:b-f231d914-c165-43f0-ab6b-1fe5755f6626',
            ],
        )
        for r in resources:
            _assert_mq_security_group_ports(base_test, r, local_session)


class PolicyTest_SpecificBroker(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['BrokerArn'],
            'arn:aws:mq:us-east-1:111111111111:broker:mq-broker-345-red:b-f231d914-c165-43f0-ab6b-1fe5755f6627',
        )
        _assert_mq_security_group_ports(base_test, resources[0], local_session)


class PolicyTest_NoFoundBrokers(object):

    def test_resources_with_client(self, base_test, resources, local_session):
        base_test.assertEqual(len(resources), 0)
