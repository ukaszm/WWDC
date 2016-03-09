//
//  ViewController.swift
//  Html
//
//  Created by Łukasz Majchrzak on 06/03/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Kanna

class ViewController: UIViewController {
    //typealias videoData = (title:String, path:String, img:String)
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer?
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = [(title:String, path:String, img:String?)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseHtml()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //playVideoAVPlayer()
        //playVideoAVPlayerViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
    }
    
    func parseHtml() {
        let dateStart = NSDate()
        //guard let url = NSURL(string: "https://developer.apple.com/videos/wwdc2014/") else { return }
        guard let url = NSURL(string: "https://developer.apple.com/videos/wwdc2015/") else { return }
        //guard let url = NSURL(string: "https://developer.apple.com/videos/play/wwdc2015/802/") else { return }
        guard let data = NSData(contentsOfURL: url) else { return }
        //guard let html = NSString(data: data, encoding: NSUTF8StringEncoding) else { return }
        //print(html)
        
        guard let doc = Kanna.HTML(html: data, encoding: NSUTF8StringEncoding) else { return }
        
//        let links = doc.css("a, link").map({ return ($0["href"] ?? "") }).filter({ $0.containsString("/videos/play/") ?? false})
//        print(links)
        
        let nodes = doc.css("li.collection-item")
        for node in nodes {
            let title = node.css("h5").first?.text ?? ""
            print(title)
            let image = node.css("img").first?["src"]
            print(image)
            let link = "https://developer.apple.com" + (node.css("a").first?["href"] ?? "")
            print(link)
            print("#####################")
            
            dataSource.append((title, link, image))
        }
        
        let interval = NSDate().timeIntervalSince1970 - dateStart.timeIntervalSince1970//dateStart.timeIntervalSinceDate(NSDate())
        print("time: \(interval)")
    }
    
    func downloadHtml() {
        let url = NSURL(string: "https://developer.apple.com/videos/wwdc2015/")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data, response, error) -> Void in
            print("error: \(error)")
            print("response: \(response)")
            
            guard let data = data else { return }
            let html = NSString(data: data, encoding: NSUTF8StringEncoding)
            print(html)
        }
        task.resume()
    }
    
    func playVideoAVPlayerViewController(path: String) {
//        let videoUrl = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//        let videoUrl = NSURL(string: "https://developer.apple.com/videos/images/ogg_bumper_no_tv.ogv")
//        let videoUrl = NSURL(string: "http://devstreaming.apple.com/videos/wwdc/2015/408509vyudbqvts/408/408_sd_protocoloriented_programming_in_swift.mp4?dl=1")
        let videoUrl = NSURL(string: path)
        player = AVPlayer(URL: videoUrl!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        presentViewController(playerViewController, animated: true) { () -> Void in
            self.player.play()
        }
    }
    
    func playVideoAVPlayer() {
//        let videoUrl = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//        let videoUrl = NSURL(string: "https://developer.apple.com/videos/images/ogg_bumper_no_tv.ogv")
        let videoUrl = NSURL(string: "http://devstreaming.apple.com/videos/wwdc/2015/408509vyudbqvts/408/408_sd_protocoloriented_programming_in_swift.mp4?dl=1")
        player = AVPlayer(URL: videoUrl!)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.frame = view.bounds
        view.layer.addSublayer(playerLayer!)
        player.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let url = NSURL(string: dataSource[indexPath.row].path) else { return }
        guard let data = NSData(contentsOfURL: url) else { return }
        guard let doc = Kanna.HTML(html: data, encoding: NSUTF8StringEncoding) else { return }
        
        guard let link = doc.css("li.video").first?.css("a").last?["href"] else { return }

        playVideoAVPlayerViewController(link)
    }
}

