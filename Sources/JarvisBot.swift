//
//  JarvisBot.swift
//  JarvisBot
//
//  Created by Emre Cakirlar on 1/13/17.
//
//

import Foundation
import SlackKit

let kSlackToken = "xoxb-YOUR_SLACK_API_TOKEN";

class JarvisBot: MessageEventsDelegate, ChannelEventsDelegate
{
    let utils = Utils();
    let bot: SlackKit;
    let actions = Actions();
    
    init(token: String)
    {
        bot = SlackKit(withAPIToken: kSlackToken);
        bot.onClientInitalization =
        {
            (client: Client) in
            DispatchQueue.main.async(execute:
            {
                client.messageEventsDelegate = self;
                client.channelEventsDelegate = self;
            });
        }
    }
    
    // MARK: MessageEventsDelegate
    func received(_ message: Message, client: Client)
    {
        if message.user != client.authenticatedUser?.id // if message is not from Jarvis, himself
        {
            if let id = client.authenticatedUser?.id
            {
                if message.text!.contains(id) // mentioning Jarvis
                {
                    self.handleMentionToSelf(message: message, client: client)
                }
                else if(message.text!.contains("joined the channel")) // Welcome Message
                {
                    self.handleWelcomeMessage(message: message, client: client);
                    
                }
            }
        }
    }
    func changed(_ message: Message, client: Client) {}
    func deleted(_ message: Message?, client: Client) {}
    func sent(_ message: Message, client: Client) {}
    
    // MARK: ChannelEventsDelegate
    func joined(_ channel: Channel, client: Client)
    {
        if let _ = client.authenticatedUser?.id
        {
            // Greetings Message
            client.webAPI.sendMessage(channel: channel.name!,
                text: "Yo What's up #\(channel.name!), it's your boy J.A.R.V.I.S. over here!",
                username: nil, asUser: true,
                parse:nil, linkNames: true,
                attachments: nil, unfurlLinks: nil, unfurlMedia: nil,
                iconURL: nil, iconEmoji: nil, success: nil, failure: nil);
        }
    }
    func userTypingIn(_ channel: Channel, user: User, client: Client){}
    func marked(_ channel: Channel, timestamp: String, client: Client){}
    func created(_ channel: Channel, client: Client){}
    func deleted(_ channel: Channel, client: Client){}
    func renamed(_ channel: Channel, client: Client){}
    func archived(_ channel: Channel, client: Client){}
    func historyChanged(_ channel: Channel, client: Client){}
    func left(_ channel: Channel, client: Client){}
    
    
    // MARK: Message Handlers
    fileprivate func handleMentionToSelf(message: Message, client: Client)
    {
        if let messageText = message.text?.lowercased(with: Locale(identifier: "en_US")), let channel = message.channel
        {
            if(messageText.contains("gif")) // Send a random gif by tag when Jarvis mentioned with gif [tag]
            {
                var tag = "";
                for item in messageText.components(separatedBy: "gif ")
                {
                    if(!item.contains((client.authenticatedUser?.id?.lowercased())!))
                    {
                        tag.append(item);
                    }
                }
                actions.gif.sendRandomGifByTag(message: message, client: client, tag: tag);
            }
            else if(messageText.contains("songs")) // Post top or trending charts by genre (e.g: @jarvis top rap songs)
            {
                let genre = utils.getGenreForMusic(messageText: messageText);
                var type = "top";
                if(messageText.contains("top"))
                {
                    type = "top";
                }
                else if(messageText.contains("trending"))
                {
                    type = "trending";
                }
                actions.sc.getCharts(message: message, client: client, type: type, genre: genre);
            }
            else // Send a Random Gif when Jarvis mentioned
            {
                actions.gif.sendRandomGif(message: message, client: client);
            }
        }
    }
    
    fileprivate func handleWelcomeMessage(message: Message, client: Client)
    {
        var userNames = "";
        var welcomeText = "";
        var channelName = "";
        var userCount = 0;
        
        for user in client.users.values
        {
            if message.text!.contains(user.id!)
            {
                userNames += "@\(user.name!) ";
                userCount += 1;
            }
        }
        channelName += utils.findChannel(by: message.channel!, client: client)!.name!;
        
        welcomeText += (userCount > 1)
            ? userNames + "welcome guys, enjoy your time in #\(channelName) Cheers!"
            : "Welcome " + userNames + "enjoy your time in #\(channelName) dawg!";
        
        client.webAPI.sendMessage(
            channel: message.channel!,
            text: welcomeText,
            username: nil, asUser: true,
            parse:nil, linkNames: true,
            attachments: nil, unfurlLinks: nil, unfurlMedia: nil,
            iconURL: nil, iconEmoji: nil, success: nil, failure: nil);
        
    }
}
