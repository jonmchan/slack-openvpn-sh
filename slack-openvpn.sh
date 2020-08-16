#!/bin/bash

# Params blatently stolen from https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f - thanks Drew

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -a|--action)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        ACTION_ARG=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -h|--webhookUrl)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        WEBHOOK_URL_ARG=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

WEBHOOK_URL=""


if ! [ -z ${SLACK_WEBHOOK_URL+x} ]; then
  echo "1"
  WEBHOOK_URL=$SLACK_WEBHOOK_URL
fi

if ! [ -z ${WEBHOOK_URL_ARG+x} ]; then
  echo "2"
  WEBHOOK_URL=$WEBHOOK_URL_ARG
fi

if [ -z "$WEBHOOK_URL" ]; then
  echo "Webhook url is unset, please set webhook url by passing --webhookUrl or as an environment variable SLACK_WEBHOOK_URL."
  exit
fi

echo $ACTION_ARG

ACTION_TYPE=''

if [ "$ACTION_ARG" == 'connect' ]; then
  ACTION_TYPE='connection'
elif [ "$ACTION_ARG" == 'disconnect' ]; then
  ACTION_TYPE='disconnection'
fi

wget  --header='Content-Type:application/json' --post-data="{\"text\": \"Type: New $ACTION_TYPE\nCommon Name: $common_name\"}" $WEBHOOK_URL -o /dev/null

exit 0
