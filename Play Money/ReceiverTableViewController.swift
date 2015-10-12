//
//  ReceiverTableViewController.swift
//  Play Money
//
//  Created by Richard Neitzke on 10/10/15.
//  Copyright © 2015 Richard Neitzke. All rights reserved.
//

import UIKit

class ReceiverTableViewController: UITableViewController {

    var players = PlayerModel()
    var delegate = TransferMoneyViewController()
    
    //Refreshs the PlayerModel and playerCollectionView everytime this View appears
    override func viewWillAppear(animated: Bool) {
        let tbc = self.tabBarController as! PlayerTabBarController
        players = tbc.players
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.players.count+1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        //The first cell is the Bank-Cell and has it's own routine
        if indexPath.item == 0 {
            cell!.textLabel?.text = "Bank"
            if delegate.receiver.0 == -1 && delegate.receiver.1 == "Bank" {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            return cell!
        }

        cell!.textLabel!.text = players.players[indexPath.item-1].name
        
        //Sets Checkmark behind Cell when it's the currently selected receiver in the delegate, removes it when not
        if delegate.receiver.0 == indexPath.item-1 && delegate.receiver.1 == players.players[indexPath.item-1].name {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        //Disables the Cell if it's Player is already the Sender
        if delegate.sender.0 == indexPath.item-1 && delegate.sender.1 == players.players[indexPath.item-1].name {
            cell!.textLabel!.textColor = UIColor.grayColor()
            cell!.userInteractionEnabled = false
        }
        
        return cell!
    }
    
    //Sets the delegates receiver to selected player and pops view
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == 0 {delegate.receiver = (-1, "Bank") } else { delegate.receiver = (indexPath.item-1, players.players[indexPath.item-1].name) }
        navigationController!.popViewControllerAnimated(true)
    }

}
