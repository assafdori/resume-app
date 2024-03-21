import requests
import time
import yaml
from typing import Dict
from slack import WebClient
from slack.errors import SlackApiError

def load_config():
    with open("config.yaml", "r") as file:
        return yaml.safe_load(file)

def send_slack_message(message, slack_token, channel_id):
    try:
        client = WebClient(token=slack_token)
        response = client.chat_postMessage(channel=channel_id, text=message)
        assert response["message"]["text"] == message
        print("Message sent successfully: ", message)
    except SlackApiError as e:
        print(f"Error sending message: {e.response['error']}")

def check_health(config: Dict[str, str]):
    slack_token = config["SLACK-TOKEN"]
    channel_id = config["CHANNEL-ID"]
    while True:
        url = f'http://{config["URL-ENDPOINT"]}/resume.pdf'
        try:
            response = requests.get(url)
            if response.status_code == 200:
                send_slack_message("Health check passed!", slack_token, channel_id)  # Send success message to Slack
                print("Health check passed!")
            else:
                send_slack_message(f"Health check failed with status code: {response.status_code}", slack_token, channel_id)  # Send failure message to Slack
                print(f"Health check failed with status code: {response.status_code}")
        except requests.ConnectionError:
            send_slack_message("Failed to connect to the server", slack_token, channel_id)  # Send failure message to Slack
            print("Failed to connect to the server")
        time.sleep(300)

if __name__ == "__main__":
    config = load_config()
    check_health(config=config)