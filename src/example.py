import json
import os
from lib_example.response import success, failure


# function: initialization
def initialization():
    pass


# function: lambda invoker handler
def handler(event, context):
    print "Received event: {}".format(json.dumps(event))

    status = 200
    if status == 200:
        response = success("success")
    else:
        response = failure("failure")
    print "response={}".format(response)

    return response


# initialization, mapping
env1 = os.environ['ENV1']
env2 = os.environ['ENV2']
initialization()

