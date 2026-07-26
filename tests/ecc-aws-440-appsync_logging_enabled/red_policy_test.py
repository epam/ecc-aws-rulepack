# Copyright (c) 2023 EPAM Systems, Inc.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


def _assert_no_log_config(base_test, r):
    base_test.assertNotIn('logConfig', r)


class PolicyTest(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 2)
        base_test.assertCountEqual(
            [r['arn'] for r in resources],
            [
                'arn:aws:appsync:us-east-1:1111111111:apis/t2ke7ood6bfnhdgdradmseb6z4',
                'arn:aws:appsync:us-east-1:1111111111:apis/w3lf8pood7cgoiehesenwtf7a5',
            ],
        )
        for r in resources:
            _assert_no_log_config(base_test, r)


class PolicyTest_SpecificGraphqlApi(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 1)
        base_test.assertEqual(
            resources[0]['arn'],
            'arn:aws:appsync:us-east-1:1111111111:apis/t2ke7ood6bfnhdgdradmseb6z4',
        )
        _assert_no_log_config(base_test, resources[0])


class PolicyTest_NoFoundGraphqlApis(object):

    def test_resources(self, base_test, resources):
        base_test.assertEqual(len(resources), 0)
