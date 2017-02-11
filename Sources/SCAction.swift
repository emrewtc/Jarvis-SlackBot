//
//  SCAction.swift
//  JarvisBot
//
//  Created by Emre Cakirlar on 2/11/17.
//
//

import Foundation
import SlackKit

let kSoundCloudClientId = "YOUR_SOUNDCLOUD_CLIENT_ID";
let kSoundCloudEndpoint = "https://api-v2.soundcloud.com/";

public class SCAction
{
    
    let utils = Utils();
    
    public func getCharts(message: Message, client: Client, type: String? = "top", genre: String? = "all-music", limit: Int? = 5)
    {
        let queryItems =
        [
            "genre":"soundcloud:genres:" + genre!,
            "query_urn":"soundcloud:charts:bcbe7304cbb84c779205f152f17c53eb",
            "offset":"0",
            "kind":type!, // top || trending
            "limit":String(format:"%d", limit!),
            "client_id":kSoundCloudClientId
        ];
        
        utils.dispatch(with: nil, urlString: kSoundCloudEndpoint + "charts",
            queryItems: queryItems, bodyParams: nil,
            success:
            {   (response) in
                
                var attachments : [Attachment] = [];
                for item in (response?["collection"])! as! Array<Dictionary<String, Any>>
                {
                    let track = item["track"] as! Dictionary<String, Any>
                    let title = track["title"] ?? "";
                    let text = track["permalink_url"] ?? "";
                    let imageURL = track["artwork_url"] ?? "";
                    
                    let attachment = Attachment(fallback: "", title:title as! String, callbackID: nil, type: nil, colorHex: "#3AA3E3", pretext:nil, authorName: nil, authorLink: nil, authorIcon:nil, titleLink: nil,
                                                text: text as? String,
                                                fields:nil, actions: nil, imageURL: imageURL as? String, thumbURL: nil,
                                                footer: nil, footerIcon:nil, ts:nil);
                    
                    attachments.append(attachment);
                }
                client.webAPI.sendMessage(
                    channel: message.channel!,
                    text: String(format:"%@ SONGS", type!, genre!).uppercased(),
                    username: nil, asUser: true,
                    parse:nil, linkNames: true,
                    attachments: attachments, unfurlLinks: nil, unfurlMedia: nil,
                    iconURL: nil, iconEmoji: nil, success: nil, failure: nil);
                
            },
            fail:
            {  (error) in
                print("Request error!!!!!: \(error)");
                
            });
    }
}
