//
//  MasterViewController.swift
//  Events App
//
//  Created by Gladwin Dosunmu on 15/09/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import CoreData
import Parse

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var detailViewController: DetailViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
        
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
                        
                        if let results = jsonResult["results"] as? NSDictionary {
                            
                            if let eventData = results["collection1"] as? NSArray {
                                
                                let request = NSFetchRequest(entityName: "ForumEvents")
                                
                                request.returnsObjectsAsFaults = false
                                
                                do {
                                    
                                    let results = try context.executeFetchRequest(request)
                                    
                                    if results.count > 0 {
                                        
                                        for result in results {
                                            
                                            context.deleteObject(result as! NSManagedObject)
                                            
                                            do { try context.save() } catch {}
                                            
                                        }
                                        
                                    }
                                    
                                } catch {}
                                
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
                                                        
                                                        do { try context.save() } catch {}
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
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
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
            
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
        // Tried: return self.fetchedResultsController.fetchedObjects!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
        cell.textLabel!.text = object.valueForKey("eventTitle")!.description
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("ForumEvents", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "eventTitle", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
}

