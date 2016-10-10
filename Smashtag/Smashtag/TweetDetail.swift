//
//  TweetDetail.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/2/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import Twitter

enum MentionType{
    case Image(TweetImage)
    case Url(String)
    case Hashtag(String)
    case User(String)
}

struct TweetDetail {
    var sections: [String]
    var numSections: Int {
        return sections.count
    }
    var data: [String:[MentionType]]
    var user: String
}

struct TweetImage {
    var url: NSURL
    var aspectRatio: Double?
}

func tweetDetailFromTweet(tweet: Twitter.Tweet) -> TweetDetail {
    // Converts an instance of the Tweet class into a TweetDetail object for use in the TweetDetailView
    var tweetDetail = TweetDetail(sections: [String](), data: [String : [MentionType]](), user: tweet.user.screenName)
    
    // Add images
    if tweet.media.count > 0 {
        tweetDetail.sections.append("images")
        tweetDetail.data["images"] = tweet.media.map({(media: Twitter.MediaItem) -> MentionType in
            let tweetImage = TweetImage(url: media.url, aspectRatio: media.aspectRatio)
            return MentionType.Image(tweetImage)
        })
    }
    
    // Add URLs
    if tweet.urls.count > 0 {
        tweetDetail.sections.append("urls")
        tweetDetail.data["urls"] = tweet.urls.map({ (mention: Twitter.Mention) -> MentionType in
            return MentionType.Url(mention.keyword)
        })
    }
    
    // Add Hashtags
    if tweet.hashtags.count > 0 {
        tweetDetail.sections.append("hashtags")
        tweetDetail.data["hashtags"] = tweet.hashtags.map({ (hashtag: Twitter.Mention) -> MentionType in
            return MentionType.Hashtag(hashtag.keyword)
        })
    }
    
    // Add Users
    if tweet.userMentions.count > 0 {
        tweetDetail.sections.append("users")
        tweetDetail.data["users"] = tweet.userMentions.map({ (user: Twitter.Mention) -> MentionType in
            return MentionType.User(user.keyword)
        })
    }
    
    return tweetDetail
}


func attributedStringFromTweet(tweet: Twitter.Tweet) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: tweet.text)
    let fullString = tweet.text as NSString
    
    let hashtagAttributes = [NSForegroundColorAttributeName: UIColor.greenColor()]
    let urlAttributes = [NSForegroundColorAttributeName: UIColor.blueColor()]
    let userAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
    
    // Turn the hashtags red
    for hashtag in tweet.hashtags {
        let charRange = fullString.rangeOfString(hashtag.keyword)
        attributedString.addAttributes(hashtagAttributes, range: charRange)
    }
    
    for url in tweet.urls {
        let charRange = fullString.rangeOfString(url.keyword)
        attributedString.addAttributes(urlAttributes, range: charRange)
    }
    
    for userMention in tweet.userMentions {
        let charRange = fullString.rangeOfString(userMention.keyword)
        attributedString.addAttributes(userAttributes, range: charRange)
    }
    
    return attributedString
    
}







