//
//  SecondViewController.swift
//  Play Money
//
//  Created by Richard Neitzke on 10/6/15.
//  Copyright © 2015 Richard Neitzke. All rights reserved.
//

import UIKit

class TransferMoneyViewController: UITableViewController {
    
    var players = PlayerModel()
    var sender = (8, "Sender")
    var receiver = (8, "Receiver")
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var senderDetailLabel: UILabel!
    @IBOutlet weak var receiverDetailLabel: UILabel!
    
    @IBAction func editingDidBegin(sender: UITextField) {
        
        //Create a button bar for the decimal number pad
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        //Setup of the done button and spaceholder to align right
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "hideKeyboard")
        let spaceholder = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: "")
        
        //Put button into toolbar and display toolbar
        keyboardDoneButtonView.setItems([spaceholder, doneButton], animated: false)
        sender.inputAccessoryView = keyboardDoneButtonView
    }
    
    //Hides keyboard
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    //Returns true when the sender is exisiting
    var validSender: Bool {
        get {
            if sender.0 == -1 && sender.1 == "Bank" { return true }
            return !players.players.isEmpty && sender.0 < players.players.count && sender.1 == players.players[sender.0].name }
    }
    
    //Returns true when the receiver is existing
    var validReceiver: Bool {
        get {
            if receiver.0 == -1 && receiver.1 == "Bank" { return true }
            return !players.players.isEmpty && receiver.0 < players.players.count && receiver.1 == players.players[receiver.0].name }
    }
    
    //Refreshs the PlayerModel and playerCollectionView and Labels everytime this View appears
    override func viewWillAppear(animated: Bool) {
        
        let tbc = tabBarController as! PlayerTabBarController
        players = tbc.players

        //Sets the Sender Label to the currently selected Sender
        if validSender {
            senderDetailLabel.text = sender.1
        }
        
        //Sets the Receiver Label to the currently selected Receiver
        if validReceiver {
            receiverDetailLabel.text = receiver.1
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //Resets the Sender Label when the saved sender isn't valid anymore
        if !validSender {
            tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))!.detailTextLabel!.text = "Sender"
        }
        
        //Resets the Receiver Label when the saved sender isn't valid anymore
        if !validReceiver {
            tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 1, inSection: 0))!.detailTextLabel!.text = "Receiver"
        }

        
    }
    
    //Checks if the Segue goes to Sender- or Receiver Table, sets itself as delegate if yes
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSenderTable" {
            print("Segue to Sender Table")
            let tvc = segue.destinationViewController as! SenderTableViewController
            tvc.delegate = self
        } else if segue.identifier == "showReceiverTable" {
            print("Segue to Receiver Table")
            let tvc = segue.destinationViewController as! ReceiverTableViewController
            tvc.delegate = self
        }
    }
    
    //Deselects cell and hides keyboard when cell is selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
        //Handles the Transfer Money Button by checking for valid Sender/Receiver and transfering the Money
        if indexPath == NSIndexPath(forItem: 0, inSection: 2) {
            if validSender && validReceiver {
                
                var amount = 200
                if !amountTextField.text!.isEmpty { amount = Int(amountTextField.text!)! }
                
                //Transfers the Money by executing the Method on the PlayerModel
                players.transferMoney(sender.0, receiverIndex: receiver.0, amount: amount, sender: self)
                tabBarController?.selectedIndex = 0
                
            } else {
                print("ERROR - Invalid Sender/Receiver")
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hideKeyboard()
    }
    
}

