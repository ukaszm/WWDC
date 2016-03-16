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
    @IBOutlet weak var filterTextField: UITextField!
    
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
    
    //MARK: Actions
    @IBAction func filterTextFieldEditingChangedAction(sender: UITextField) {
        guard let filterText = sender.text else { return }
        dataManager.applyFilter(filterText) { () -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
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
        let item = dataManager.itemAtIndexPath(indexPath)
        cell.textLabel?.attributedText = nil
        cell.textLabel?.text = item.title
        if let range = item.selectedRange {
            let attText = NSMutableAttributedString(string: item.title)
            attText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: range)
            cell.textLabel?.attributedText = attText
        }
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        guard let videoUrlString = dataManager.videoUrlForItemAtIndexPath(indexPath) else { return }
        playVideoAVPlayerViewController(videoUrlString)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        filterTextField.resignFirstResponder()
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

