//
//  Utils.swift
//  JarvisBot
//
//  Created by Emre Cakirlar on 1/9/17.
//
//

import Foundation
import SlackKit

public class Utils
{
    public func findUser(with id: String, client: Client) -> User?
    {
        for user in client.users.values
        {
            if id == user.id!
            {
                return user as User;
            }
        }
        return nil;
    }
    
    public func findChannel(by id:String, client: Client) -> Channel?
    {
        for channel in client.channels.values
        {
            if id == channel.id!
            {
                return channel as Channel;
            }
        }
        return nil;
    }
    
    // Genre Types for SoundCloud Action
    public func getGenreForMusic(messageText: String) -> String
    {
        var genre = "all-music"
        for item in messageText.components(separatedBy: " ")
        {
            switch item
            {
            case "rap":
                genre = "hiphoprap";
                break;
            case "rnb", "r&b":
                genre = "rbsoul"
                break;
            case "dancehall":
                genre = "dancehall"
                break;
            case "rock":
                genre = "rock"
                break;
            case "metal":
                genre = "metal"
                break;
            case "reggae":
                genre = "reggae"
                break;
            case "dubstep":
                genre = "dubstep"
                break;
            case "electronic":
                genre = "electronic"
                break;
            default:
                break;
            }
        }
        return genre;
    }
    
    public func dispatch(with method: String?, urlString: String,
                         queryItems: Dictionary<String,String>?, bodyParams: Dictionary<String, AnyObject>?,
                         success: @escaping ((_ response: Dictionary<String, AnyObject>?)->Void),
                         fail: @escaping ((_ error: Error?)->Void))
    {
        // Prepare url
        var urlComponents = URLComponents(string: urlString);
        var queryItemArr = Array<URLQueryItem>();
        if(queryItems != nil)
        {
            for item in queryItems!
            {
                queryItemArr.append(URLQueryItem(name: item.key, value: item.value));
                print("KEY \(item.key)");
                print("VALUE \(item.value)");
            }
        }
        urlComponents?.queryItems = queryItemArr;
        
        // Prepare request
        var urlRequest = URLRequest(url: (urlComponents?.url)!);
        print("Absolute string \(urlComponents?.url)");
        
        for item in queryItemArr
        {
            print("\(item)");
        }
        
        if(bodyParams != nil)
        {
            let jsonBody = try? JSONSerialization.data(withJSONObject: bodyParams!);
            urlRequest.httpBody = jsonBody;
        }
        urlRequest.httpMethod = method ?? "GET";
        
        // Prepare session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // Check for any errors
            guard error == nil
                else
            {
                fail(error);
                return
            }
            // Make sure we got data
            guard let responseData = data
                else
            {
                print("Error: did not receive data")
                success(nil);
                return
            }
            // Parse the result as JSON, since that's what the API provides
            do {
                guard let response = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject]
                    else
                {
                    print("error trying to convert data to JSON")
                    success(nil);
                    return
                }
                success(response);
            }
            catch
            {
                print("error trying to convert data to JSON")
                success(nil);
                return
            }
        }
        
        task.resume()
        
    }
}
