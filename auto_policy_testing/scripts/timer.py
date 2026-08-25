import time
from logger import get_logger


logger = get_logger(__name__)


# defining a timer decorator
def time_decorator(func):
    def wrap(*args, **kwargs):
        start_time = time.time()
        logger.info("Start processing")
        result = func(*args, **kwargs)
        end_time = time.time()
        elapsed_time = end_time - start_time
        minutes = int(elapsed_time // 60)
        seconds = int(elapsed_time % 60)
        logger.info("Finish processing: [%s min %s sec elapsed]", minutes, seconds)
        return result
    return wrap