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
    typealias SectionData = (title: String, videos: [VideoData])
    
    static let sharedInstance = DataManager()
    fileprivate init() {}
    
    //MARK: properties
    fileprivate let dataManagerQueue = DispatchQueue(label: "dataManagerQueue", attributes: DispatchQueue.Attributes.concurrent)

    fileprivate var videoDataCollection = [VideoDataColletion]()
    fileprivate var sensitiveVideoData = [SectionData]()
    fileprivate var videoData: [SectionData] {
        var dataCopy = [SectionData]()
        dataManagerQueue.sync { [weak self] () -> Void in
            dataCopy = self?.sensitiveVideoData ?? []
        }
        return dataCopy
    }
    
    //MARK: fetching data
    func fetchDataWithCompletion(_ completion: (()->())?) {
        
        for (title,path) in Configuration.videoPaths {
            let videoCollection = VideoDataColletion(collectionTitle: title, videoCollectionPath: path)
            videoDataCollection.append(videoCollection)
            videoCollection.fetchDataWithCompletion({ [weak self] () -> () in
                self?.applyFilter("", completion: completion)
            })
        }
    }

    
    //MARK: dataSource methods
    func numberOfDataSections() -> Int {
        return videoData.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int{
        return videoData[section].videos.count
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> VideoData {
        return videoData[indexPath.section].videos[indexPath.row]
    }
    
    func sectionNameAtIndex(_ index: Int) -> String {
        return videoData[index].title
    }
    
    func numberOfCellForIndexPath(_ indexPath: IndexPath) -> Int {
        var number = 0
        for i in 0..<indexPath.section {
            let (_, videos) = videoData[i]
            number += videos.count
        }
        return number + indexPath.row
    }
    
    func videoUrlForItemAtIndexPath(_ indexPath: IndexPath) -> String? {
        let videoItem = itemAtIndexPath(indexPath)
        guard let url = URL(string: videoItem.path) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let doc = Kanna.HTML(html: data, encoding: String.Encoding.utf8) else { return nil}
        
        guard let videoUrlString = doc.css(Configuration.queryForVideoItemInVideoPage).first?.css(Configuration.queryForVideoLinksInVideoPage) else { return nil }
            
        guard videoUrlString.count > 0 else { return nil }
        return videoUrlString[videoUrlString.count-1][Configuration.queryForVideoUrlInVideoPage]
    }
    
    //consider making it async
    func applyFilter(_ filter: String, completion: (() -> ())?) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async { [weak self] () -> Void in
            var tmpVideoData = [SectionData]()
            guard let videoDataCollection = self?.videoDataCollection else { return }
            for data in videoDataCollection {
                data.applyFilterSync(filter)
                if data.outputData.count == 0 { continue }
                tmpVideoData.append((data.collectionTitle, data.outputData))
            }
            guard let queue = self?.dataManagerQueue else { return }
            queue.async(flags: .barrier, execute: { [weak self] () -> Void in
                self?.sensitiveVideoData = tmpVideoData
                completion?()
            })
           
        }
    }
}
