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
    let cellColors = UIColor.appRowsColors()
    
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateStart = NSDate()
        
        dataManager.fetchDataWithCompletion { [weak self] () -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?.tableView.reloadData()
                print("time: \(NSDate().timeIntervalSince1970 - dateStart.timeIntervalSince1970)")
            })
        }
        
        let interval = NSDate().timeIntervalSince1970 - dateStart.timeIntervalSince1970
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
    
    @IBAction func clearButtonAction(sender: AnyObject) {
        dataManager.applyFilter("") { () -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.filterTextField.text = ""
                self.tableView.reloadData()
            })
        }
    }

    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataManager.numberOfDataSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.numberOfItemsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath) as! VideoDataTableViewCell
        let item = dataManager.itemAtIndexPath(indexPath)
        cell.titleLabel?.attributedText = nil
        cell.titleLabel?.text = item.title
        if let range = item.selectedRange {
            let attText = NSMutableAttributedString(string: item.title)
            attText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: range)
            cell.titleLabel?.attributedText = attText
        }
        cell.backgroundColor = cellColors[dataManager.numberOfCellForIndexPath(indexPath) % cellColors.count]
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if tableView.indexPathForSelectedRow == indexPath {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.beginUpdates()
            tableView.endUpdates()
            return nil
        }
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.beginUpdates()
        tableView.endUpdates()

        //return
        guard let videoUrlString = dataManager.videoUrlForItemAtIndexPath(indexPath) else { return }
        playVideoAVPlayerViewController(videoUrlString)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        filterTextField.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataManager.sectionNameAtIndex(section)
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return tableView.indexPathForSelectedRow == indexPath ? 200 : 64
//    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

