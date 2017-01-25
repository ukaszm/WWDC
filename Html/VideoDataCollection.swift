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
    fileprivate let videoCollectionPath: String
    fileprivate var sensitiveVideoData = [VideoData]()
    fileprivate var sensitiveOutputData = [VideoData]()

    fileprivate let concurentVideoDataQueue = DispatchQueue(label: "videoDataQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    fileprivate var videoData: [VideoData] {
        var dataCopy = [VideoData]()
        concurentVideoDataQueue.sync { [weak self] () -> Void in
            dataCopy = self?.sensitiveVideoData ?? []
        }
        return dataCopy
    }
    
    var outputData: [VideoData] {
        var dataCopy = [VideoData]()
        concurentVideoDataQueue.sync { [weak self] () -> Void in
            dataCopy = self?.sensitiveOutputData ?? []
        }
        return dataCopy
    }
    
    init(collectionTitle: String, videoCollectionPath: String) {
        self.collectionTitle = collectionTitle
        self.videoCollectionPath = videoCollectionPath
    }
    
    func fetchDataWithCompletion(_ completion: (()->())?) {
        guard let url  = URL(string: videoCollectionPath) else { return }
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest, completionHandler: { [weak self] (nsData, nsUrlResponse, nsError) -> Void in
            
            guard let data = nsData else { return }
            guard let doc  = Kanna.HTML(html: data, encoding: String.Encoding.utf8) else { return }
            let serverPath = Configuration.serverPath
            let nodes = doc.css(Configuration.queryForItemInVideoList)
            
            var dataSource = [VideoData]()
            for node in nodes {
                let title = node.css(Configuration.queryForTitleInVideoLisItem).first?.text ?? ""
                let link = serverPath + (node.css(Configuration.queryForLinksInVideoListItem).first?[Configuration.queryForVideoPageInVideoListItem] ?? "")
                
                dataSource.append(VideoData(title: title, path: link, selectedRange: nil))
            }
            guard let queue = self?.concurentVideoDataQueue else { return }
            queue.async(flags: .barrier, execute: { () -> Void in
                self?.sensitiveVideoData = dataSource
                self?.sensitiveOutputData = dataSource
                completion?()
            })
        }) 
        task.resume()
    }
    
    func applyFilterSync(_ filter: String) {
        var videoBuff = [VideoData]()
        if filter.isEmpty {
            videoBuff = videoData
        }
        else {
            videoBuff = videoData.filter({$0.title.uppercased().contains(filter.uppercased())})
            
            for (index,data) in videoBuff.enumerated() {
                let title: NSString = data.title.uppercased() as NSString
                videoBuff[index].selectedRange = title.range(of: filter.uppercased())
            }
        }
        concurentVideoDataQueue.sync(flags: .barrier, execute: { [weak self] () -> Void in
            self?.sensitiveOutputData = videoBuff
        }) 
    }
}
