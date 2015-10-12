//
//  AboutViewController.swift
//  Play Money
//
//  Created by Richard Neitzke on 10/7/15.
//  Copyright © 2015 Richard Neitzke. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController {
    
    @IBOutlet weak var versionLabel: UILabel!

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let githubIndexPath = NSIndexPath(forItem: 1, inSection: 0)
        let icon8IndexPath = NSIndexPath(forItem: 1, inSection: 2)
        
        //Opens up the Links for GitHub and Resources in Safari
        switch indexPath {
        case githubIndexPath : UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/richardxyx")!)
        case icon8IndexPath : UIApplication.sharedApplication().openURL(NSURL(string: "https://icons8.com")!)
        default: break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        let dictionary = NSBundle.mainBundle().infoDictionary!
        versionLabel.text = dictionary["CFBundleShortVersionString"] as? String
    }

}
