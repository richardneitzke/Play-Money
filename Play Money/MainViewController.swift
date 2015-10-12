//
//  FirstViewController.swift
//  Play Money
//
//  Created by Richard Neitzke on 10/6/15.
//  Copyright © 2015 Richard Neitzke. All rights reserved.
//

import UIKit
import Realm
import RealmSwift


class MainViewController: UICollectionViewController {
    
    @IBOutlet var playerCollectionView: UICollectionView!
    
    //Initializes with an empty PlayerModel
    var players = PlayerModel()
    
    //Refreshs the PlayerModel and playerCollectionView everytime this View appears
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let tbc = self.tabBarController as! PlayerTabBarController
        players = tbc.players
        playerCollectionView.reloadData()
    }
    
    //Returns amount of players
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.players.count
    }
    
    //Returns PlayerCell with correct Player Data
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PlayerCell
        let player = players.players[indexPath.item]
        cell.nameLabel.text = player.name
        cell.balanceLabel.text = "$\(player.balance)"
        cell.imageView.image = UIImage(named: player.tokenString)
        
        return cell
    }
    
    //Handles Touches on PlayerCells
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let player = players.players[indexPath.item]
        
        print("Cell \(indexPath.item) selected!")
        
        //Creates the Main ActionSheet
        let ac = UIAlertController(title: "\(player.name) - $\(player.balance)", message: "What do you want to do with this Player?", preferredStyle: .ActionSheet)
        
        //Adds a Function to quick add $200 to a Player
        ac.addAction(UIAlertAction(title: "Add $200", style: .Default, handler: { aa in
            self.players.addMoney(player, amount: 200)
            self.playerCollectionView.reloadData()
        }))
        
        //Adds a Function to quick send Money to another Player
        ac.addAction(UIAlertAction(title: "Send Money to...", style: .Default, handler: {aa in
            self.transferWithSender()
        }))
        
        //Adds a Function to quick receive Money from another Player
        ac.addAction(UIAlertAction(title: "Receive Money from...", style: .Default, handler: {aa in
            self.transferWithReceiver()
        }))
        
        //Adds a Function to rename Players
        ac.addAction(UIAlertAction(title: "Rename", style: .Default, handler: { aa in
            let acRename = UIAlertController(title: "Rename \(player.name):", message: nil, preferredStyle: .Alert)
            acRename.addTextFieldWithConfigurationHandler({ tf in
                tf.text = player.name
            })
            acRename.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            acRename.addAction(UIAlertAction(title: "Rename", style: .Default, handler: { ac in
                self.players.renamePlayer(player, newName: acRename.textFields!.first!.text!)
                self.playerCollectionView.reloadData()
            }))
            self.presentViewController(acRename, animated: true, completion: nil)
        }))
        
        //Adds a Function to delete Players
        ac.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { aa in
            self.players.deletePlayer(player)
            self.playerCollectionView.reloadData()
        }))
        
        //Addds a Cancel-Button
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        //Presents the ActionSheet
        self.presentViewController(ac, animated: true, completion: nil)
    
    }
    
    //Function for Quick-Transaction
    func transferWithSender() {
        
        //Makes the TransferMoneyViewController available to the Function
        let nvc = tabBarController!.viewControllers![1] as! UINavigationController
        let transferViewController = nvc.viewControllers[0] as! TransferMoneyViewController
        
            //Initializes a Player with data of the Bank-Player
            var senderPlayer = (-1, "Bank")
        
            //Sets the last selected Player as the senderPlayer
            for i in 0...players.players.count-1 {
                let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0))! as! PlayerCell
                if cell.selected { senderPlayer = (i, cell.nameLabel.text!) }
            }
        
            //Sets the sender-property of the TransferMoneyViewController to the selected Player
            transferViewController.sender = senderPlayer
        
            //Changes the View to the TransferMoneyViewController
            tabBarController!.selectedIndex = 1
        
            //Shows the Receiver-Table in the TransferMoneyViewController
            transferViewController.performSegueWithIdentifier("showReceiverTable", sender: transferViewController)
        
    }
    
    //Function for Quick-Transaction
    func transferWithReceiver() {
        
        //Makes the TransferMoneyViewController available to the Function
        let nvc = tabBarController!.viewControllers![1] as! UINavigationController
        let transferViewController = nvc.viewControllers[0] as! TransferMoneyViewController
        
        //Initializes a Player with data of the Bank-Player
        var receiverPlayer = (-1, "Bank")
        
        //Sets the last selected Player as the senderPlayer
        for i in 0...players.players.count-1 {
            let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0))! as! PlayerCell
            if cell.selected { receiverPlayer = (i, cell.nameLabel.text!) }
        }
        
        //Sets the receiver-property of the TransferMoneyViewController to the selected Player
        transferViewController.receiver = receiverPlayer
        
        //Changes the View to the TransferMoneyViewController
        tabBarController!.selectedIndex = 1
        
        //Shows the Sender-Table in the TransferMoneyViewController
        transferViewController.performSegueWithIdentifier("showSenderTable", sender: transferViewController)
        
    }

}

