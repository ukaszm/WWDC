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
    @IBOutlet var filterTextFieldToolbar: UIToolbar!
    
    let dataManager = DataManager.sharedInstance
    let cellColors = UIColor.appColors()
    
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTextField.inputAccessoryView = filterTextFieldToolbar
        
        let dateStart = Date()
        
        dataManager.fetchDataWithCompletion { [weak self] () -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                self?.tableView.reloadData()
                print("time: \(Date().timeIntervalSince1970 - dateStart.timeIntervalSince1970)")
            })
        }
        
        let interval = Date().timeIntervalSince1970 - dateStart.timeIntervalSince1970
        print("time: \(interval)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: private
    fileprivate func playVideoAVPlayerViewController(_ path: String) {
        let videoUrl = URL(string: path)
        player = AVPlayer(url: videoUrl!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) { () -> Void in
            self.player.play()
        }
    }
    
    //MARK: Actions
    @IBAction func filterTextFieldEditingChangedAction(_ sender: UITextField) {
        guard let filterText = sender.text else { return }
        dataManager.applyFilter(filterText) { () -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func clearButtonAction(_ sender: AnyObject) {
        dataManager.applyFilter("") { () -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                self.filterTextField.text = ""
                self.tableView.reloadData()
            })
        }
    }

    @IBAction func filterTextFieldDoneAction(_ sender: AnyObject) {
        filterTextField.resignFirstResponder()
    }
    
    
}

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.numberOfDataSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoDataTableViewCell
        let item = dataManager.itemAtIndexPath(indexPath)
        cell.titleLabel?.attributedText = nil
        cell.titleLabel?.text = item.title
        if let range = item.selectedRange {
            let attText = NSMutableAttributedString(string: item.title)
            attText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellow, range: range)
            cell.titleLabel?.attributedText = attText
        }
        cell.backgroundColor = cellColors[dataManager.numberOfCellForIndexPath(indexPath) % cellColors.count]
        return cell
    }
}

//MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.beginUpdates()
            tableView.endUpdates()
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()
        tableView.endUpdates()

        guard let videoSiteUrl = URL(string: dataManager.itemAtIndexPath(indexPath).path) else { return }
        UIApplication.shared.openURL(videoSiteUrl)

        //guard let videoUrlString = dataManager.videoUrlForItemAtIndexPath(indexPath) else { return }
        //playVideoAVPlayerViewController(videoUrlString)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        filterTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataManager.sectionNameAtIndex(section)
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return tableView.indexPathForSelectedRow == indexPath ? 200 : 64
//    }
}

//MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

