import time


# defining a timer decorator
def time_decorator(func):
    def wrap(*args, **kwargs):
        start_time = time.time()
        print("Start processing")
        result = func(*args, **kwargs)
        end_time = time.time()
        elapsed_time = end_time - start_time
        minutes = int(elapsed_time // 60)
        seconds = int(elapsed_time % 60)
        print(f"Finish processing: [{minutes} min {seconds} sec elapsed]")
        return result
    return wrap