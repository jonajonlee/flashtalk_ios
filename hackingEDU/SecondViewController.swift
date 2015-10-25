//
//  SecondViewController.swift
//  hackingEDU
//
//  Created by Jonathan Lee on 10/23/15.
//  Copyright © 2015 leej40. All rights reserved.
//

import UIKit



class SecondViewController: UIViewController, UITextFieldDelegate {

/*###########################################*/
// object variables
/*###########################################*/
    
    @IBOutlet weak var newItemField: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var delayLabel: UILabel!

/*###########################################*/
// configure delay
/*###########################################*/
    
    @IBAction func delaySet(sender: UISlider) {
        delaySec = Int(slider.value)
        delayLabel.text = String(Int(slider.value*2)) + " sec"
    }

/*###########################################*/
// add new item
/*###########################################*/
    
    @IBAction func AddNewPressed(sender: AnyObject) {
        
        itemArr.append(newItemField.text!)
        NSUserDefaults.standardUserDefaults().setObject(itemArr, forKey: "itemArr")
        newItemField.text = ""
        newItemField.resignFirstResponder()
    }

/*###########################################*/
// keyboard control and view setup
/*###########################################*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newItemField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
    
        newItemField.resignFirstResponder()
        AddNewPressed(self)
        return true
    }
}

