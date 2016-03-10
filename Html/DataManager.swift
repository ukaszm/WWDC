//
//  DataManager.swift
//  Html
//
//  Created by Łukasz Majchrzak on 10/03/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import Foundation
import Kanna


final class DataManager {
    static let sharedInstance = DataManager()
    private init() {}
    
    //MARK: resource paths
    let serverPath = "https://developer.apple.com"
    let videoPaths = ["https://developer.apple.com/videos/wwdc2015/",
                      "https://developer.apple.com/videos/wwdc2014/",
                      "https://developer.apple.com/videos/wwdc2013/"]
    
    //MARK: properties
    var dataSource = [VideoData]()
    
    //MARK: fetching data
    func fetchData() {
        for videoPath in videoPaths {
            fetchDataFromURL(videoPath)
        }
    }
    
    private func fetchDataFromURL(urlString: String) {
        guard let url  = NSURL(string: urlString) else { return }
        guard let data = NSData(contentsOfURL: url) else { return }
        guard let doc  = Kanna.HTML(html: data, encoding: NSUTF8StringEncoding) else { return }
        
        let nodes = doc.css("li.collection-item")
        for node in nodes {
            let title = node.css("h5").first?.text ?? ""
            //let image = node.css("img").first?["src"]
            let link = serverPath + (node.css("a").first?["href"] ?? "")
            
            dataSource.append(VideoData(title: title, path: link, img: nil))
        }
    }
    

    
    //MARK: dataSource methods
    func numberOfDataSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int{
        return dataSource.count
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> VideoData {
        return dataSource[indexPath.row]
    }
    
    func videoUrlForItemAtIndexPath(indexPath: NSIndexPath) -> String? {
        let videoItem = itemAtIndexPath(indexPath)
        guard let url = NSURL(string: videoItem.path) else { return nil }
        guard let data = NSData(contentsOfURL: url) else { return nil }
        guard let doc = Kanna.HTML(html: data, encoding: NSUTF8StringEncoding) else { return nil}
        
        guard let videoUrlString = doc.css("li.video").first?.css("a").last?["href"] else { return nil }
        return videoUrlString
    }
}
