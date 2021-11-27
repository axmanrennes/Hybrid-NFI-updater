#!/bin/bash

ROOT_PATH="/root"
NFI_PATH="${ROOT_PATH}/NostalgiaForInfinity/NostalgiaForInfinityX.py"
NFI_BLACKLIST_PATH="${ROOT_PATH}/NostalgiaForInfinity/configs/blacklist-binance.json"
NFI_PAIRLIST_PATH="${ROOT_PATH}/NostalgiaForInfinity/configs/pairlist-volume-binance-usdt.json"
FT_PATH="${ROOT_PATH}/freqtrade/user_data/strategies/NostalgiaForInfinityX.py"
FT_CONFIG_PATH="${ROOT_PATH}/freqtrade/user_data/custom_config"
TG_TOKEN="XXX"
TG_CHAT_ID="XXX"
GIT_URL="https://github.com/iterativv/NostalgiaForInfinity"

# Go to NFI directory
cd $(dirname ${NFI_PATH})

# Fetch latest tags
git fetch --tags

# Get tags names
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
current_tag=$(git describe --tags)

# Create a new branch with the latest tag name and copy the new version of the strategy
if [ "$latest_tag" != "$current_tag" ]; then

        # Checkout to latest tag and update the NFI in Freqtrade folder
        git checkout tags/$latest_tag -b $latest_tag || git checkout $latest_tag
        cp $NFI_PATH $FT_PATH
        cp $NFI_BLACKLIST_PATH $FT_CONFIG_PATH
        cp $NFI_PAIRLIST_PATH $FT_CONFIG_PATH

        # Get tag to which the latest tag is pointing
        latest_tag_commit=$(git rev-list -n 1 tags/${latest_tag})

                # Compose the main message send by the bot
        curl -s --data "text=NFI is updated to tag: *${latest_tag}* . Please wait for reload..." \
                --data "parse_mode=markdown" \
                --data "chat_id=$TG_CHAT_ID" \
                "https://api.telegram.org/bot${TG_TOKEN}/sendMessage"

        sleep 120

        cd $(dirname ${FT_PATH})
        docker-compose down > /dev/null &&
        docker-compose build --pull > /dev/null &&
        docker-compose up -d --remove-orphans > /dev/null &&
        docker system prune --volumes -af > /dev/null

        curl -s --data "text=NFI reload has been completed!" \
                --data "parse_mode=markdown" \
                --data "chat_id=$TG_CHAT_ID" \
                "https://api.telegram.org/bot${TG_TOKEN}/sendMessage"
fi
