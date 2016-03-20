//
//  VideoDataCollection.swift
//  Html
//
//  Created by Łukasz Majchrzak on 20/03/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import Foundation
import Kanna

final class VideoDataColletion {

    let collectionTitle: String
    private let videoCollectionPath: String
    private var sensitiveVideoData = [VideoData]()
    private var sensitiveOutputData = [VideoData]()

    private let concurentVideoDataQueue = dispatch_queue_create("videoDataQueue", DISPATCH_QUEUE_CONCURRENT)
    
    private var videoData: [VideoData] {
        var dataCopy = [VideoData]()
        dispatch_sync(concurentVideoDataQueue) { [weak self] () -> Void in
            dataCopy = self?.sensitiveVideoData ?? []
        }
        return dataCopy
    }
    
    var outputData: [VideoData] {
        var dataCopy = [VideoData]()
        dispatch_sync(concurentVideoDataQueue) { [weak self] () -> Void in
            dataCopy = self?.sensitiveOutputData ?? []
        }
        return dataCopy
    }
    
    init(collectionTitle: String, videoCollectionPath: String) {
        self.collectionTitle = collectionTitle
        self.videoCollectionPath = videoCollectionPath
    }
    
    func fetchDataWithCompletion(completion: (()->())?) {
        guard let url  = NSURL(string: videoCollectionPath) else { return }
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest) { [weak self] (nsData, nsUrlResponse, nsError) -> Void in
            
            guard let data = nsData else { return }
            guard let doc  = Kanna.HTML(html: data, encoding: NSUTF8StringEncoding) else { return }
            let serverPath = Configuration.serverPath
            let nodes = doc.css(Configuration.queryForItemInVideoList)
            
            var dataSource = [VideoData]()
            for node in nodes {
                let title = node.css(Configuration.queryForTitleInVideoLisItem).first?.text ?? ""
                let link = serverPath + (node.css(Configuration.queryForLinksInVideoListItem).first?[Configuration.queryForVideoPageInVideoListItem] ?? "")
                
                dataSource.append(VideoData(title: title, path: link, selectedRange: nil))
            }
            guard let queue = self?.concurentVideoDataQueue else { return }
            dispatch_barrier_async(queue, { () -> Void in
                self?.sensitiveVideoData = dataSource
                self?.sensitiveOutputData = dataSource
                completion?()
            })
        }
        task.resume()
    }
    
    func applyFilterSync(filter: String) {
        var videoBuff = [VideoData]()
        if filter.isEmpty {
            videoBuff = videoData
        }
        else {
            videoBuff = videoData.filter({$0.title.uppercaseString.containsString(filter.uppercaseString)})
            
            for (index,data) in videoBuff.enumerate() {
                let title: NSString = data.title.uppercaseString
                videoBuff[index].selectedRange = title.rangeOfString(filter.uppercaseString)
            }
        }
        dispatch_barrier_sync(concurentVideoDataQueue) { [weak self] () -> Void in
            self?.sensitiveOutputData = videoBuff
        }
    }
}
