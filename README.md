# Jarvis-SlackBot

Jarvis is a [Slack](https://slack.com) bot, built with [SlackKit](https://github.com/pvzig/SlackKit) using Swift.

* Jarvis can 
  * greet the channel which he joined.
  * welcome people who just joined the channel.
  * share a random gif from [GIPHY](http://giphy.com/) when someone mentioned him.
  * share a random gif by tag when someone mentioned him with `gif [tag]` format.
  * bring top or trending charts by genre from [SoundCloud](https://soundcloud.com/) when someone mentioned him with `[top ||   trending] [genre(optional)] songs` format.


Replace your bot’s API token with `xoxb-YOUR_SLACK_API_TOKEN` in `JarvisBot.swift` in order to run Jarvis on [Slack](https://slack.com)
```swift 
let kSlackToken = "xoxb-YOUR_SLACK_API_TOKEN"
```

In order to use [SoundCloud](https://soundcloud.com/) action, you will need to replace `YOUR_SOUNDCLOUD_CLIENT_ID` in  `SCAction.swift` with your own SoundCloud Client ID which you can get from [SoundCloud](https://soundcloud.com/).
```swift
let kSoundCloudClientId = "YOUR_SOUNDCLOUD_CLIENT_ID";
```



