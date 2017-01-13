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
        utils.dispatch(with: nil, urlString: kGiphyEndpoint + "random",
        queryItems: queryItems, bodyParams: nil,
        success:
        {  (response) in
            let attachments = Attachment(fallback: "fallback Required plain-text summary of the attachment.", title:"Random Gif", callbackID: nil, type: nil, colorHex: "#3AA3E3", pretext:nil, authorName: nil, authorLink: nil, authorIcon:nil, titleLink: nil,
                text: response?["data"]?["url"] as! String?,
                fields:nil, actions: nil, imageURL: response?["data"]?["image_url"] as! String?, thumbURL: nil,
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
