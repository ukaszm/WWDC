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
    private var dataSource = [VideoData]()
    private var outputData = [VideoData]()
    
    //MARK: fetching data
    func fetchData() {
        for videoPath in videoPaths {
            fetchDataFromURL(videoPath)
        }
    }
    
    //consider making it async (handle thread safe read/write dataSource and outputData arrays)
    private func fetchDataFromURL(urlString: String) {
        guard let url  = NSURL(string: urlString) else { return }
        guard let data = NSData(contentsOfURL: url) else { return }
        guard let doc  = Kanna.HTML(html: data, encoding: NSUTF8StringEncoding) else { return }
        
        let nodes = doc.css("li.collection-item")
        for node in nodes {
            let title = node.css("h5").first?.text ?? ""
            //let image = node.css("img").first?["src"]
            let link = serverPath + (node.css("a").first?["href"] ?? "")
            
            dataSource.append(VideoData(title: title, path: link, img: nil, selectedRange: nil))
            
        }
        outputData = dataSource
    }
    

    
    //MARK: dataSource methods
    func numberOfDataSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int{
        return outputData.count
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> VideoData {
        return outputData[indexPath.row]
    }
    
    func videoUrlForItemAtIndexPath(indexPath: NSIndexPath) -> String? {
        let videoItem = itemAtIndexPath(indexPath)
        guard let url = NSURL(string: videoItem.path) else { return nil }
        guard let data = NSData(contentsOfURL: url) else { return nil }
        guard let doc = Kanna.HTML(html: data, encoding: NSUTF8StringEncoding) else { return nil}
        
        guard let videoUrlString = doc.css("li.video").first?.css("a").last?["href"] else { return nil }
        return videoUrlString
    }
    
    //consider making it async
    func applyFilter(filter: String, completion: (() -> ())?) {
        if filter.isEmpty {
            outputData = dataSource
        }
        else {
            outputData = dataSource.filter({$0.title.uppercaseString.containsString(filter.uppercaseString)})
            
            for (index,data) in outputData.enumerate() {
                let title: NSString = data.title.uppercaseString
                outputData[index].selectedRange = title.rangeOfString(filter.uppercaseString)
            }
        }
        completion?()
    }
}
