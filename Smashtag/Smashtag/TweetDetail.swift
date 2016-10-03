//
//  TweetDetail.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/2/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import Twitter

struct ImageMention {
    var cellType = "ImageCell"
    var url: NSURL
}

struct StandardMention {
    var cellType: String
    var data: String
}

enum MentionType{
    case image(ImageMention)
    case url(StandardMention)
    case hashtag(StandardMention)
    case user(StandardMention)
}

struct TweetDetail {
    var sections: [String]
    var data: [String:MentionType]
}

