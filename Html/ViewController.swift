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
    var player: AVPlayer!
    @IBOutlet weak var tableView: UITableView!
    
    let dataManager = DataManager.sharedInstance
    
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateStart = NSDate()
        
        dataManager.fetchData()
        
        let interval = NSDate().timeIntervalSince1970 - dateStart.timeIntervalSince1970//dateStart.timeIntervalSinceDate(NSDate())
        print("time: \(interval)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: private
    private func playVideoAVPlayerViewController(path: String) {
        let videoUrl = NSURL(string: path)
        player = AVPlayer(URL: videoUrl!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        presentViewController(playerViewController, animated: true) { () -> Void in
            self.player.play()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.numberOfItems()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath)
        cell.textLabel?.text = dataManager.itemAtIndexPath(indexPath).title
        return cell
    }
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        guard let videoUrlString = dataManager.videoUrlForItemAtIndexPath(indexPath) else { return }
        playVideoAVPlayerViewController(videoUrlString)
    }
}

