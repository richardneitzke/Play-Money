//
//  PlayerModel.swift
//  Play Money
//
//  Created by Richard Neitzke on 10/7/15.
//  Copyright © 2015 Richard Neitzke. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class PlayerModel {

    let realm = try! Realm()
    
    var players: [Player] {
        get {
            var players = [Player]()
            
            for item in realm.objects(Player) {
                players.append(item)
            }
            
            return players
        }
    }
    
    //Returns whether Token is in use or not
    func tokenInUse(index:Int) -> Bool {
        for var i = 0; i < players.count; i++ {
            if players[i].token == index { return true }
        }
        return false
    }
    
    //Adds Player to storage
    func addPlayer(player:Player) {
        realm.write({
            self.realm.add(player)
        })
    }
    
    //Checks Transfers for validity and transfers Money
    func transferMoney(senderIndex:Int, receiverIndex:Int, amount:Int, sender:UITableViewController) {
        
        //Checks if Sender and Receiver is Bank
        if senderIndex == -1 && receiverIndex == -1 {
            print("Error: Tried to transfer $\(amount) from Bank to Bank!")
            return
        }
        
        //Handles Transfers out of the Bank
        if senderIndex == -1 {
            let player = realm.objects(Player)[receiverIndex]
            addMoney(player, amount: amount)
            print("Gave \(player.name) $\(amount) out of the Bank.")
            return
        }
        
        //Handles Transfers to the Bank
        if receiverIndex == -1 {
            let player = realm.objects(Player)[senderIndex]
            if player.balance >= amount {
                removeMoney(player, amount: amount)
                print("\(player.name) paid $\(amount) to the Bank.")
            } else { notEnoughMoneyError(player.name, sender: sender) }
            
            return
        }
        
        let senderPlayer = realm.objects(Player)[senderIndex]
        let receiverPlayer = realm.objects(Player)[receiverIndex]
        
        if senderPlayer.balance >= amount {
            addMoney(receiverPlayer, amount: amount)
            removeMoney(senderPlayer, amount: amount)
            print("\(senderPlayer.name) paid $\(amount) to \(receiverPlayer.name).")
        } else { notEnoughMoneyError(senderPlayer.name, sender: sender) }
        
    }
    
    //Adds Money to an account
    func addMoney(player:Player, amount:Int) {
        realm.write({
            player.balance += amount
        })
    }
    
    //Removes Money from an account
    func removeMoney(player:Player, amount:Int) {
        realm.write({
            player.balance -= amount
        })
    }
    
    //Shows UIAlert when a Player has not enough Money for a Transaction
    func notEnoughMoneyError(playerName:String, sender:UITableViewController) {
        let ac = UIAlertController(title: "Could not transfer Moeny", message: "\(playerName) has not enough Money to perform this Transaction!", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
        sender.presentViewController(ac, animated: true, completion: nil)
    }
    
    //Deletes Player
    func deletePlayer(index:Int) {
        deletePlayer(realm.objects(Player)[index])
    }
    
    func deletePlayer(player:Player) {
        realm.write({
            self.realm.delete(player)
        })
    }
    
    //Renames Player
    func renamePlayer(index:Int, newName:String) {
        renamePlayer(realm.objects(Player)[index], newName: newName)
    }
    
    func renamePlayer(player:Player, newName:String) {
        realm.write({
            player.name = newName
        })
    }
    
}
