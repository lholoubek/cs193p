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
    case Image(NSURL)
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

func tweetDetailFromTweet(tweet: Twitter.Tweet) -> TweetDetail {
    // Converts an instance of the Tweet class into a TweetDetail object for use in the TweetDetailView
    var tweetDetail = TweetDetail(sections: [String](), data: [String : [MentionType]](), user: tweet.user.screenName)
    
    // Add images
    if tweet.media.count > 0 {
        tweetDetail.sections.append("images")
        tweetDetail.data["images"] = tweet.media.map({(media: Twitter.MediaItem) -> MentionType in
            return MentionType.Image(media.url)
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
    
