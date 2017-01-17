//
//  GifAction.swift
//  JarvisBot
//
//  Created by Emre Cakirlar on 1/13/17.
//
//

import Foundation
import SlackKit

let kGiphyAPIToken = "dc6zaTOxFJmzC"; // GIPHY public beta api token -> https://github.com/Giphy/GiphyAPI
let kGiphyEndpoint = "http://api.giphy.com/v1/gifs/"

public class GifAction
{
    let utils = Utils();
    
    public func sendRandomGif(message: Message, client: Client)
    {
        let queryItems =
        [
            "api_key": kGiphyAPIToken
        ];
        randomGif(queryItems: queryItems, title: "Random Gif", message: message, client: client);
    }
    
    public func sendRandomGifByTag(message: Message, client: Client, tag: String)
    {
        let queryItems =
        [
            "api_key": kGiphyAPIToken,
            "tag": tag
        ];
        randomGif(queryItems: queryItems, title: String(format:"%@ Gif", tag.capitalized(with: Locale(identifier: "en_US"))), message: message, client: client);
    }
    
    fileprivate func randomGif(queryItems: Dictionary<String,String>?, title: String, message: Message, client: Client)
    {
        utils.dispatch(with: nil, urlString: kGiphyEndpoint + "random",
            queryItems: queryItems, bodyParams: nil,
            success:
            {  (response) in
                let text = response?["data"]?["url"] ?? "http://giphy.com/gifs/no-nope-jay-z-SH5dYg10Gpjvq";
                let imageURL = response?["data"]?["image_url"] ?? "https://media0.giphy.com/media/SH5dYg10Gpjvq/giphy.gif"
                let attachments = Attachment(fallback: "", title:title, callbackID: nil, type: nil, colorHex: "#3AA3E3", pretext:nil, authorName: nil, authorLink: nil, authorIcon:nil, titleLink: nil,
                                             text: text as! String?,
                                             fields:nil, actions: nil, imageURL: imageURL as! String?, thumbURL: nil,
                                             footer: nil, footerIcon:nil, ts:nil);
                
                client.webAPI.sendMessage(
                    channel: message.channel!,
                    text: "",
                    username: nil, asUser: true,
                    parse:nil, linkNames: true,
                    attachments: [attachments], unfurlLinks: nil, unfurlMedia: nil,
                    iconURL: nil, iconEmoji: nil, success: nil, failure: nil);
            },
            fail:
            {   (error) in
                print("Request error!: \(error)");
            });
    }
}
