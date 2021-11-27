# Hybrid-NFIX-updater

A bash script which checks [NostalgiaForInfinityX](https://github.com/iterativv/NostalgiaForInfinity) for newly added tags and updates it for usage with the [Freqtrade](https://github.com/freqtrade/freqtrade) bot.  
After updating it rebuilds and reloads the docker container.

## Credits
Copy-pasted parts from https://github.com/krsh-off/nfi-tags-auto-update and from https://github.com/lobap/NostalgiaForInfinity_Update  

which both were inspired by https://github.com/shanejones/nfi-auto-update 

I only did the mashup, all credit goes to the people mentioned above.

## Installation

Clone the repo:
```
git clone https://github.com/StudyRemy/Hybrid-NFI-updater.git
```

Open `NFI_updates.sh` file and tweak some variables:

- `ROOT_PATH` - path to the directory where `NostalgiaForInfinityNext` and `freqtrade` directories are places
- `NFI_BLACKLIST_PATH` - path to the blacklist NFI configuration
- `NFI_PAIRLIST_PATH` - path to the pairlist NFI configuration
- `FT_CONFIG_PATH` - path to the custom configuration directory of freqtrade docker
- Check if `NFI_PATH` and `FT_PATH` are correct
- `TG_TOKEN` - Telegram token you've got for the bot
- `TG_CHAT_ID` - Telegram chat ID with your bot

Make the file executable:
```
chmod +x NFI_updates.sh
```

Setup a cronjob to execute the script periodically.

Log into your server and type `crontab -e`.  
Edit the cron file, add in the following line at the bottom of the file.

Next you should be editing the cron file, add in the following line at the bottom of the file. This will run every 2/7/12/17...52/57 minutes past the hour and it does will not clash with the with the 5 min candles calculations. h/t @abanchev for this tip! We can also add an option to automatically start the bot should the server reboot for whatever reason.
```
2-59/5 * * * * /bin/bash -c "/root/Hybrid-NFI-updater/NFI_updates.sh" > /root/updater.log 2>&1
```

Once that is saved, the updater will check for new git updates
