//
//  User.swift
//  Twitter
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

// container to hold data about a Twitter user

public class User: NSObject
{
    public let screenName: String
    public let name: String
    public let id: String
    public let verified: Bool
    public let profileImageURL: NSURL?
    
    public override var description: String { return "@\(screenName) (\(name))\(verified ? " ✅" : "")" }
    
    // MARK: - Internal Implementation
    
    init?(data: NSDictionary?) {
        guard
            let screenName = data?.value(forKeyPath: TwitterKey.ScreenName) as? String,
            let name = data?.value(forKeyPath: TwitterKey.Name) as? String,
            let id = data?.value(forKeyPath: TwitterKey.ID) as? String
        else {
            return nil
        }
        
        self.screenName = screenName
        self.name = name
        self.id = id

        self.verified = (data?.value(forKeyPath: TwitterKey.Verified) as AnyObject).boolValue ?? false
        let urlString = data?.value(forKeyPath: TwitterKey.ProfileImageURL) as? String ?? ""
        self.profileImageURL = (urlString.characters.count > 0) ? NSURL(string: urlString) : nil
    }
    
    var asPropertyList: [String:AnyObject] {
        return [
            TwitterKey.Name:name as AnyObject,
            TwitterKey.ScreenName:screenName as AnyObject,
            TwitterKey.ID:id as AnyObject,
            TwitterKey.Verified:verified ? "YES" as AnyObject : "NO" as AnyObject,
            TwitterKey.ProfileImageURL:profileImageURL?.absoluteString as AnyObject? ?? "" as AnyObject
        ]
    }
    
    struct TwitterKey {
        static let Name = "name"
        static let ScreenName = "screen_name"
        static let ID = "id_str"
        static let Verified = "verified"
        static let ProfileImageURL = "profile_image_url"
    }
}
