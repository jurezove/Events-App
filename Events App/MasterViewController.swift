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
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context : NSManagedObjectContext = appDel.managedObjectContext
        
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
                        
                        var request = NSFetchRequest(entityName: "ForumEvents")
                        
                        request.returnsObjectsAsFaults = false
                        
                        do {
                            
                            var results = try context.executeFetchRequest(request)
                            
                            if results.count > 0 {
                                
                                for result in results {
                                    
                                    context.deleteObject(result as! NSManagedObject)
                                    
                                    do { try context.save() } catch {}
                                    
                                }
                                
                            }
                            
                        } catch {}
                        
                        if let results = jsonResult["results"] as? NSDictionary {
                            
                            if let eventData = results["collection1"] as? NSArray {
                                
                                for event in eventData {
                                    
                                    if let eventTitle = event["EventTitle"] as? NSDictionary {
                                        
                                        if let eventTitleText = eventTitle["text"] as? String {
                                            
                                            if let eventDate = event["EventDate"] as? String {
                                                
                                                if let eventTicketLink = event["EventTicketLink"] as? NSDictionary {
                                                    
                                                    if let eventLink = eventTicketLink["href"] as? String {
                                                        
                                                        let newEvent : NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("ForumEvents", inManagedObjectContext: context)
                                                        
                                                        newEvent.setValue(eventTitleText, forKey: "eventTitle")
                                                        
                                                        newEvent.setValue(eventDate, forKey: "eventDate")
                                                        
                                                        newEvent.setValue(eventLink, forKey: "eventLink")
                                                        
                                                        do {
                                                            
                                                            try context.save()
                                                            
                                                        } catch {}
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    let request = NSFetchRequest(entityName: "ForumEvents")
                    
                    request.returnsObjectsAsFaults = false
                    
                    do {
                        
                        let results = try context.executeFetchRequest(request)
                        
                        print(results)
                        
                    } catch {}
                    
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

