import urllib3
import json


def handler(event, context):
    slack_url = "https://hooks.slack.com/services/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"
    http = urllib3.PoolManager()
    msg = {"text": "Alarm was triggered!",}

    encoded_msg = json.dumps(msg).encode("utf-8")
    resp = http.request("POST", slack_url, body=encoded_msg)
    print({"message": msg, "status_code": resp.status, "response": resp.data,})