//
//  AddPlayerViewController.swift
//  Play Money
//
//  Created by Richard Neitzke on 10/6/15.
//  Copyright © 2015 Richard Neitzke. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class AddPlayerViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var players = PlayerModel()
    
    @IBOutlet weak var tokenCell: UITableViewCell!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var tokenCollectionView: UICollectionView!
    
    //Adds Observer for device rotation, calls rotated() when device was rotated
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    //Reloads Token Chooser to keep taken Tokens disabled
    func rotated() {
        tokenCollectionView.reloadData()
    }
    
    //Returns the correct size of the Token Chooser cell
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.item == 2 { if UIDevice.currentDevice().orientation.isLandscape { return 87 } else { return 170 } }
        return 44
    }
    
    //Refreshs the PlayerModel and playerCollectionView everytime this View appears & hides Keyboard
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let tbc = self.tabBarController as! PlayerTabBarController
        players = tbc.players
        tokenCollectionView.reloadData()
        hideKeyboard()
    }
    
    //Hides Keyboard if return is pressed after entering name
    @IBAction func nameReturn(sender: UITextField) {
        hideKeyboard()
    }

    //Add a "done"-Button to the NumberKeyBoard
    @IBAction func balanceEditingBegin(sender: UITextField) {
        
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
    
    //Hides the Keyboard
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    //TokenCollectionViewController
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    //Tokens
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = tokenCollectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TokenCell
        cell.imageView.image = UIImage(named: tokenImageForIndex(indexPath.item))
        cell.layer.borderWidth = 0
        
        //Makes cell transparent when the token is already in use
        if players.tokenInUse(indexPath.item) { cell.layer.opacity = 0.3 }
        
        return cell
    }
    
    //Draws border around a selected cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        for i in 0...7 {
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0))! as! TokenCell
            if cell.selected && !players.tokenInUse(i) {
                cell.imageView.image = UIImage(named: "\(tokenImageForIndex(i))_filled")
            } else {
                cell.imageView.image = UIImage(named: "\(tokenImageForIndex(i))")
                collectionView.deselectItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0), animated: false)
            }
        }
    }
    
    //Deletes border when cell is deselected
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)! as! TokenCell
        cell.imageView.image = UIImage(named: "\(tokenImageForIndex(indexPath.item))")
    }
    
    //Returns Token Name of the currently selected cell
    func selectedToken() -> Int {
        for var i = 0; i < 8; i++ {
            let cell = tokenCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0))!
            if cell.selected { return i }
        }
        return 8
        
    }
    
    //Returns Token Name for an Index
    func tokenImageForIndex(index: Int) -> String {
        switch index {
        case 0: return "Barrow"
        case 1: return "Car"
        case 2: return "Cat"
        case 3: return "Dog"
        case 4: return "Fingerhat"
        case 5: return "Hat"
        case 6: return "Ship"
        case 7: return "Shoe"
        default: return "Unknown"
        }
    }
    
    //Adds the Player to the Storage
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.isEqual(NSIndexPath(forItem: 0, inSection: 1)) {
            if selectedToken() != 8 {
                
                let player = Player()
            
                //Checks if the TextFields aren't empty and assigns the Data to the Player
                if !nameTextField.text!.isEmpty { player.name = nameTextField.text! }
                if !balanceTextField.text!.isEmpty { player.balance = Int(balanceTextField.text!)! }
                player.token = selectedToken()
            
                //Adds the Player to the PlayerModel which adds it to the Realm
                players.addPlayer(player)
                print("Added Player \(player)")
            
                //Deselects the selected Row
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                
                //Changes the view to the Main-View
                self.tabBarController!.selectedIndex = 0
                
            } else {
                
                //Shows error Alert when no Token is selected
                let ac = UIAlertController(title: "Could not add Player", message: "Please select a token!", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
            }
        }
        
        //Deselects the selected Row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


}
