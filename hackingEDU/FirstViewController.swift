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

/*###########################################*/
// global variables for app-wide access
/*###########################################*/

var itemArr = [String]()
var delaySec = 0
let speechSynth = AVSpeechSynthesizer()


class FirstViewController: UIViewController, UITableViewDelegate {

/*###########################################*/
// object variables
/*###########################################*/
    
    @IBOutlet weak var tableList: UITableView!
    
/*###########################################*/
// initial view setup
/*###########################################*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if NSUserDefaults.standardUserDefaults().objectForKey("itemArr") != nil {
            itemArr = NSUserDefaults.standardUserDefaults().objectForKey("itemArr")! as! [String]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        tableList.reloadData()
        
        //debug prints
        print("paused: " + String(speechSynth.paused))
        print("speaking: " + String(speechSynth.speaking))
        print("editing: " + String(tableList.editing))
        
    }

/*###########################################*/
// rearrange and delete rows
/*###########################################*/
    
    // edit (rearranged) button pressed
    @IBAction func startEdit(sender: UIBarButtonItem) {
        if !speechSynth.speaking || speechSynth.paused {
            tableList.editing = !tableList.editing
        }
    }
    
    // edit delegate funtion
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    // edit delegate function (rearrange)
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        

        let itemToMove = itemArr[fromIndexPath.row]
        itemArr.removeAtIndex(fromIndexPath.row)
        itemArr.insert(itemToMove, atIndex: toIndexPath.row)
        NSUserDefaults.standardUserDefaults().setObject(itemArr, forKey: "itemArr")

    }
    
    // delete
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableList.editing {
            if editingStyle == UITableViewCellEditingStyle.Delete {
                itemArr.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                NSUserDefaults.standardUserDefaults().setObject(itemArr, forKey: "itemArr")
            }
        }
    }

/*###########################################*/
// speech actions
/*###########################################*/
    
    // start button pressed
    @IBAction func startTest(sender: AnyObject) {
        
        if speechSynth.paused && !tableList.editing {
            speechSynth.continueSpeaking()
        }
        else if !speechSynth.speaking && !tableList.editing {
            itemArr = NSUserDefaults.standardUserDefaults().objectForKey("itemArr")! as! [String]
            for each in itemArr {
                let speech = AVSpeechUtterance(string: each)
                speech.postUtteranceDelay = Double(delaySec)
                speechSynth.speakUtterance(speech)
            }
        }
    }
    
    // pause button pressed
    @IBAction func pauseTest(sender: AnyObject) {
        if speechSynth.speaking && !tableList.editing {
            speechSynth.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        }
    }
    
    // stop button pressed
    @IBAction func stopTest(sender: AnyObject) {
        if !tableList.editing {
            speechSynth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
            itemArr = NSUserDefaults.standardUserDefaults().objectForKey("itemArr")! as! [String]
        }
    }
    
/*###########################################*/
// table setup
/*###########################################*/
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArr.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = itemArr[indexPath.row]
        return cell
    }
    
    

    
        
}

