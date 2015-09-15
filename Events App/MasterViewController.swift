//
//  MasterViewController.swift
//  Events App
//
//  Created by Gladwin Dosunmu on 15/09/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = NSURL(string: "https://www.kimonolabs.com/api/6tewont8?apikey=CPMj8n9tabsEUqUjKEPiHOmVir5gZjfq")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!) { (data, response, error) -> Void in
            
            if error != nil {
                
                print(error)
                
            } else {
                
                // print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                
                do {
                    
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    if jsonResult.count > 0 {
                        
                        if let results = jsonResult["results"] as? NSDictionary {
                            
                            if let eventData = results["collection1"] as? NSArray {
                                
                                for event in eventData {
                                    
                                    if let eventTitle = event["EventTitle"] as? NSDictionary {
                                        
                                        if let eventTitleText = eventTitle["text"] as? String {
                                            
                                            if let eventDate = event["EventDate"] as? String {
                                                
                                                if let eventTicketLink = event["EventTicketLink"] as? NSDictionary {
                                                    
                                                    if let eventLink = eventTicketLink["href"] as? String {
                                                        
                                                        print(eventTitleText)
                                                        print(eventDate)
                                                        print(eventLink)
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                } catch {}
                
            }
            
        }
        
        task.resume()
        
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            
            print("Show Detail")
            
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "Test"
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
}

