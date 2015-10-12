//
//  Player.swift
//  Play Money
//
//  Created by Richard Neitzke on 10/7/15.
//  Copyright © 2015 Richard Neitzke. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Player: Object {

    dynamic var name = "Unnamed Player"
    dynamic var balance = 1500
    dynamic var token = 8
    
    //Returns the Token  of the player
    var tokenString: String {
        get {
                switch self.token {
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
    }
}
