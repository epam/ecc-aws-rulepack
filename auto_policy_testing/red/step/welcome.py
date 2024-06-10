import json
import random
import string
import random
import string
import re


def lambda_handler(event, context):

    max = 8
    password = ''.join(random.choices(
        string.ascii_lowercase+string.ascii_uppercase, k=max))
    mandatory = ''.join(''.join(random.choices(choice)) for choice in [
                        string.ascii_lowercase, string.ascii_uppercase, "_@", string.digits])
    passwordlist = list(password+mandatory)
    random.shuffle(passwordlist)
    while re.match("^[0-9]|@|_", ''.join(list(passwordlist))) != None:
        random.shuffle(passwordlist)
        passwordlist = list(password+mandatory)

    return {
        'statusCode': 200,
        'body': json.dumps(''.join(list(passwordlist)))
    }
