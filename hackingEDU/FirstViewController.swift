//
//  FirstViewController.swift
//  hackingEDU
//
//  Created by Jonathan Lee on 10/23/15.
//  Copyright © 2015 leej40. All rights reserved.
//

// features to possibly add
// - variable pause between rows
// - badass gui
// - multiple subjects
// - rearrange rows



import UIKit
import AVFoundation

var itemArr = [String]()
var delaySec = 0

class FirstViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableList: UITableView!
    
    @IBAction func startEdit(sender: UIBarButtonItem) {
        
        tableList.editing = !tableList.editing
        
    }
   
    
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        let itemToMove = itemArr[fromIndexPath.row]
        itemArr.removeAtIndex(fromIndexPath.row)
        itemArr.insert(itemToMove, atIndex: toIndexPath.row)
    
    }
    
    
    let speechSynth = AVSpeechSynthesizer()
    
    // text to speech
    @IBAction func startTest(sender: AnyObject) {
        
        if speechSynth.paused {
            speechSynth.continueSpeaking()
        }
        else {
            for each in itemArr {
                let speech = AVSpeechUtterance(string: each)
                speech.postUtteranceDelay = Double(delaySec)
                speechSynth.speakUtterance(speech)
            }
        }
    }
    
    @IBAction func pauseTest(sender: AnyObject) {
        if speechSynth.speaking {
            speechSynth.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        }
    }
    
    @IBAction func stopTest(sender: AnyObject) {
        
        speechSynth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if NSUserDefaults.standardUserDefaults().objectForKey("itemArr") != nil {
            itemArr = NSUserDefaults.standardUserDefaults().objectForKey("itemArr")! as! [String]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArr.count
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            itemArr.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            NSUserDefaults.standardUserDefaults().setObject(itemArr, forKey: "itemArr")
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = itemArr[indexPath.row]
        
        return cell
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        tableList.reloadData()
            
        
    }

    
        
}

