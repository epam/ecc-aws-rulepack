import json
import logging
import logging.config
import os
from copy import deepcopy
from typing import Any, Dict, Optional, Union


DEFAULT_LOG_LEVEL = "INFO"
LOG_LEVEL_ENV_VAR = "AUTO_POLICY_TESTING_LOG_LEVEL"
DEFAULT_LOG_FORMAT = "%(asctime)s %(levelname)s [%(name)s] %(message)s"

_DEFAULT_LOGGING_CONFIG: Dict[str, Any] = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "standard": {
            "format": DEFAULT_LOG_FORMAT,
        }
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "level": DEFAULT_LOG_LEVEL,
            "formatter": "standard",
            "stream": "ext://sys.stdout",
        }
    },
    "root": {
        "level": DEFAULT_LOG_LEVEL,
        "handlers": ["console"],
    },
}

_is_configured = False
_script_log_level = DEFAULT_LOG_LEVEL
_managed_logger_names = set()


def _resolve_log_level(config_level: Optional[str] = None) -> str:
    env_level = os.getenv(LOG_LEVEL_ENV_VAR, "").strip().upper()
    if env_level and env_level in logging._nameToLevel:
        return env_level
    if config_level:
        normalized = config_level.strip().upper()
        if normalized in logging._nameToLevel:
            return normalized
    return DEFAULT_LOG_LEVEL


def _parse_json_config(config: Union[str, Dict[str, Any], None]) -> Dict[str, Any]:
    if config is None:
        return {}
    if isinstance(config, dict):
        return config
    if isinstance(config, str):
        config = config.strip()
        if not config:
            return {}
        return json.loads(config)
    raise TypeError("Logging config should be a dict, JSON string, or None")


def setup_logging(config: Union[str, Dict[str, Any], None] = None, force: bool = False) -> None:
    global _is_configured, _script_log_level
    if _is_configured and not force:
        return

    parsed_config = _parse_json_config(config)
    logging_config = deepcopy(_DEFAULT_LOGGING_CONFIG)

    effective_level = _resolve_log_level(parsed_config.get("level"))
    _script_log_level = effective_level
    logging_config["handlers"]["console"]["level"] = effective_level

    log_format = parsed_config.get("format")
    if isinstance(log_format, str) and log_format.strip():
        logging_config["formatters"]["standard"]["format"] = log_format

    log_file = parsed_config.get("log_file")
    if isinstance(log_file, str) and log_file.strip():
        logging_config["handlers"]["file"] = {
            "class": "logging.FileHandler",
            "level": effective_level,
            "formatter": "standard",
            "filename": log_file,
            "encoding": "utf-8",
        }
        logging_config["root"]["handlers"].append("file")

    logging.config.dictConfig(logging_config)
    for logger_name in _managed_logger_names:
        logging.getLogger(logger_name).setLevel(_script_log_level)
    _is_configured = True


def get_logger(name: Optional[str] = None) -> logging.Logger:
    if not _is_configured:
        setup_logging()
    logger = logging.getLogger(name)
    if name:
        _managed_logger_names.add(name)
        logger.setLevel(_script_log_level)
    return logger