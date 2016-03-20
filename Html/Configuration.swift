//
//  Configuration.swift
//  Html
//
//  Created by Łukasz Majchrzak on 20/03/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import Foundation

struct Configuration {
    static let serverPath = "https://developer.apple.com"
    static let videoPaths = [("WWDC 2015","https://developer.apple.com/videos/wwdc2015/"),
        ("WWDC 2014", "https://developer.apple.com/videos/wwdc2014/"),
        ("WWDC 2013","https://developer.apple.com/videos/wwdc2013/")]
    
    //todo: get these values from iCloud
    //videos list page
    static let queryForItemInVideoList = "li.collection-item"
    static let queryForTitleInVideoLisItem = "h5"
    static let queryForLinksInVideoListItem = "a"
    static let queryForVideoPageInVideoListItem = "href"
    
    //video page
    static let queryForVideoItemInVideoPage = "li.video"
    static let queryForVideoLinksInVideoPage = "a"
    static let queryForVideoUrlInVideoPage = "href"
}
