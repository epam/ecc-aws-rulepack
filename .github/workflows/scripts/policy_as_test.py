import argparse
import datetime
from importlib import import_module
import logging
import os
import re

from dateutil import tz as tzutil

from c7n.config import Config
from c7n.policy import load as policy_load
from c7n.provider import clouds
from c7n.testing import mock_datetime_now
from c7n.utils import local_session
from tests.common import BaseTest
from tools.c7n_gcp.tests.gcp_common import BaseTest as GCPBaseTest


log = logging.getLogger(__name__)


def run_test_log(session_factory, base_test, policy_test, log_message):
    if hasattr(policy_test, 'mock_time'):
        # see test_offhours.py
        year, month, day = policy_test.mock_time()
        t = datetime.datetime.now(tzutil.gettz("America/New_York"))
        t = t.replace(year=year, month=month, day=day)

        with mock_datetime_now(t, datetime):
            time_mockable_run_test_log(
                session_factory, base_test, policy_test, log_message)
    else:
        time_mockable_run_test_log(
            session_factory, base_test, policy_test, log_message)


def time_mockable_run_test_log(
        session_factory, base_test, policy_test, log_message):
    data_policy = base_test.load_policy(
        policy_data, session_factory=session_factory, config=_prepare_policy_config(
            policy_data, base_test.policy_loader.policy_config))
    resources = data_policy.run()
    if hasattr(policy_test, 'test_resources_with_client'):
        policy_test.test_resources_with_client(
            base_test, resources, local_session(session_factory))
    else:
        policy_test.test_resources(base_test, resources)
    log.info(log_message)


def _set_up_logging():
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s: %(name)s:%(levelname)s %(message)s")
    # Suppress unneeded Placebo library debug statements.
    logging.getLogger('placebo.pill').setLevel(logging.ERROR)


def _new_config(policy_file):
    return Config.empty(
        **{'region': '',
           'regions': [],
           'cache': '~/.cache/cloud-custodian.cache',
           'profile': None,
           'account_id': None,
           'assume_role': None,
           'external_id': None,
           'log_group': None,
           'tracer': None,
           'metrics_enabled': None,
           'metrics': None,
           'output_dir': 'out',
           'cache_period': 0,
           'dryrun': False,
           'authorization_file': None,
           'subparser': 'run',
           'config': None,
           'configs': [policy_file],
           'policy_filters': [],
           'resource_types': [],
           'verbose': None,
           'quiet': None,
           'debug': False,
           'skip_validation': False,
           'command': 'c7n.commands.run',
           'vars': None})


def _prepare_common_config(policy_file, placebo_dir, policy_test_module_name):
    loaded_policy = policy_load(_new_config(policy_file), policy_file).policies[0]
    policy_data = loaded_policy.data
    if policy_data['resource'].split('.')[0] == 'gcp':
        base_test = GCPBaseTest()
    else:
        base_test = BaseTest()
    base_test.placebo_dir = placebo_dir

    PolicyTest = import_module(policy_test_module_name).PolicyTest
    return base_test, policy_data, PolicyTest()


def _prepare_policy_config(policy_data, base_test_policy_config):
    provider_match = re.match('(.*?)\\..*', policy_data['resource'])
    provider_name = provider_match.group(1) if provider_match else 'aws'
    # see commands.py
    provider = clouds[provider_name]()
    return provider.initialize(base_test_policy_config)


def _parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("action", help="record or replay(test)")
    parser.add_argument("policy_file", help="path/to/policy.yaml")
    parser.add_argument("policy_test", help="package.of.policy_test "
                                            "equivalent of package/of/policy_test.py")
    parser.add_argument("output_dir", help="path/to/output/directory")
    args = parser.parse_args()
    return args.action, args.policy_file, args.policy_test, args.output_dir


if __name__ == '__main__':
    action, policy_file, policy_test_module_name, output_dir = _parse_args()
    _set_up_logging()

    placebo_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        output_dir)

    base_test, policy_data, policy_test = _prepare_common_config(
        policy_file, placebo_dir, policy_test_module_name)
    policy_name = policy_data['name']

    if action == 'record':
        session_factory = base_test.record_flight_data(policy_name)
        run_test_log(session_factory, base_test, policy_test,
                     'record policy resources successful')
    elif action in ['replay', 'test']:
        session_factory = base_test.replay_flight_data(policy_name)
        run_test_log(session_factory, base_test, policy_test,
                     'test recorded policy resources successful')
    else:
        log.info(f'invalid action: {action}, please run the script '
                 'with -h to see the possible options')
