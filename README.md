# slack-openvpn-sh


Based off of [slack-openvpn](https://github.com/kaplanmaxe/slack-openvpn). Rationale was I wanted this without requiring node installed which I do not have on my [openvpn docker container](https://github.com/kylemanna/docker-openvpn). I used wget instead of curl because that's what tools are already on the docker-openvpn image.

## Installation

Clone or just copy the script to a folder like: `/etc/openvpn/scripts` (don't forgot to chmod +x!).

Add the following lines to your openvpn config:

```
client-connect "/etc/openvpn/scripts/slack-openvpn.sh --webhookUrl YOUR_WEBHOOK_URL --action connect"
client-disconnect "/etc/openvpn/scripts/slack-openvpn.sh --webhookUrl YOUR_WEBHOOK_URL --action disconnect"
```

The script also allows you to set `SLACK_WEBHOOK_URL` as an environment variable and omit `--webhookUrl`, but I couldn't figure out why my openvpn was not passing the variable to the script, so this functionality does not work.

